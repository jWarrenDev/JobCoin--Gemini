//
//  TransactionModel.swift
//  JobCoin Wallet
//
//  Created by Jerrick Warren on 8/30/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import Foundation

// MARK: - Balance
struct Balance: Codable {
    var balance: String
    let transactions: [Transaction]
    
}

// MARK: - Transaction
struct Transaction: Codable {
    let timestamp: String?
    let toAddress: String?
    let amount: String
    let fromAddress: String?
}

//struct TransactionPost: Codable {
//    let fromAddress: String
//    let toAddrewss: String
//    let amount: String
//}
