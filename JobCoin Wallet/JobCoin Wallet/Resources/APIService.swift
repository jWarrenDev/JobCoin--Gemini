//
//  APIService.swift
//  JobCoin Wallet
//
//  Created by Jerrick Warren on 9/5/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
    case noDataAvailable
    case canNotProcessData
    case otherProblem
}

class APIService {
    
    var tc = TransactionViewController()
    
    let baseURL = "http://jobcoin.gemini.com/helpless/api/"
    static let shared = APIService()
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        case responseProblem
        case decodingProblem
        case encodingProblem
        case noDataAvailable
        case canNotProcessData
        case otherProblem
    }
    
    
    func getTransactions(completion: @escaping( Result<[Transaction], APIError>) -> Void) {
        
        guard let baseURL = URL(string: "http://jobcoin.gemini.com/helpless/api/transactions") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error performing GET request: \(error.localizedDescription)")
                completion(.failure(.otherProblem))
                return }
            
            guard let data = data else {
                NSLog("There was a problem getting data)")
                completion(.failure(.noDataAvailable))
                return }
            
            do{
                let json = try JSONDecoder().decode([Transaction].self, from: data)
                let allTransactions = json
                completion(.success(allTransactions))
                
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }

    
    func getUserBalance(user: String, completion: @escaping(Result<Balance, APIError>) -> Void)  {
    
        let jsonURLString = "https://jobcoin.gemini.com/helpless/api/addresses/\(user)"
        
        guard let url = URL(string: jsonURLString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { ( data, response, error)  in
            
            if let error = error {
                NSLog("Error performing GET request: \(error.localizedDescription)")
                completion(.failure(.otherProblem))
                return }
            
            guard let data = data else {
                NSLog("Could not get User Data")
                completion(.failure(.noDataAvailable))
                return }
            
            do {
                
                let balance = try JSONDecoder().decode(Balance.self, from: data)
                self.tc.balance = balance
                self.tc.transactions = (balance.transactions)
                completion(.success(balance))
                
            } catch let jsonErr {
                print("Error Decoding json", jsonErr)
                completion(.failure(.canNotProcessData))
            }
            
        }
        dataTask.resume()
    }
    
    func postTransaction(transaction: Transaction, completion: @escaping(Result<Transaction, APIError>) -> Void) {
    
    do {
        guard  let url = URL(string: "http://jobcoin.gemini.com/helpless/api/transactions") else { fatalError() }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(transaction)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            
            if let error = error {
                NSLog("Error performing PUT request: \(error.localizedDescription)")
                completion(.failure(.otherProblem))
                return }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseProblem))
                return }
            
            if httpResponse.statusCode == 200 {
                print("OK Transaction was sent! ")
            } else if httpResponse.statusCode == 422 {
                print("Insufficent Funds")
            } else {
                print("Unknown Response")
            }
            
        }
        dataTask.resume()
    } catch {
        completion(.failure(.encodingProblem))
    }
}

}
    

