//
//  ViewController.swift
//  JobCoinWallet
//
//  Created by Jerrick Warren on 8/30/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//


import Foundation
import UIKit
import SwiftChart


class TransactionViewController: UIViewController {
    
    // MARK: - Variables
    
    var transactions = [Transaction]()
    var balance: Balance?
    var chart = Chart()
    var personalTransactions = [Double]()
    var user: String = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CustomTransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "customCell")
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        balanceLabel.layer.zPosition = +1
        
        let frame = CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height )
        chart = Chart(frame: frame)
        chartView.addSubview(chart)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChart), name: .updatedAmount, object: nil)
       
        getUserBalance()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   
    // MARK: - Methods
    
    @objc func updateChart() {
        
        let currentBal  = personalTransactions
        let chartData   = currentBal
        let series      = ChartSeries(chartData)
        
        series.area = true
        series.color = ChartColors.blueColor()
        
        
        chart.add(series)
        chart.showXLabelsAndGrid = false
        chart.backgroundColor = .black
       // chart.highlightLineColor = .white
        chart.gridColor = .white
        chart.labelColor = .white
        
        
    }
    
    func runningBalance(){
        
        let userTransactions = self.transactions.filter({ $0.toAddress == user || $0.fromAddress == user })
        var balanceCounter: Double = 0
        self.personalTransactions = []
        
        for transaction in userTransactions {
            if transaction.toAddress == user {
                balanceCounter = balanceCounter + Double(transaction.amount)!
            } else {
                balanceCounter = balanceCounter - Double(transaction.amount)!
            }
            self.personalTransactions.append(balanceCounter)
        }
    }
    
    func getUserBalance() {
        
        APIService.shared.getUserBalance(user: self.user) { result in
            
            switch result {
            case .failure(let error):
                print(error)
            case .success(let balance):
                self.balance = balance
                self.transactions = balance.transactions
                
                DispatchQueue.main.async {
                    self.runningBalance()
                    self.balanceLabel.text = "Your Current balance is \(balance.balance) JobCoins"
                    self.updateChart()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - IBOulets and Actions
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    
    @IBAction func signOutButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false, completion:nil)
    }
    
    @IBAction func sendCoinsButtonPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "Who would you like to send Job Coins to?", message: "And How Much?", preferredStyle: .alert)
        ac.addTextField { (pTextField) in
            pTextField.placeholder      = "Name or Address"
            pTextField.clearButtonMode  = .whileEditing
            pTextField.borderStyle      = .roundedRect
            }
        ac.addTextField() { (pTextField) in
            pTextField.placeholder      = "Amount to send "
            pTextField.clearButtonMode  = .whileEditing
            pTextField.borderStyle      = .roundedRect
          
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            guard let toAddress = ac.textFields![0].text, !toAddress.isEmpty,
                let amount = ac.textFields![1].text, !amount.isEmpty else { return }
            
            self.displayMessage(title: "You have chosen to send \(amount) JobCoins to \(toAddress)", msg: "Please Confirm") {_ in
                
                let fromAddress = self.user
                let transactionPost = Transaction(timestamp: nil, toAddress: toAddress, amount: amount, fromAddress: fromAddress)
                
                APIService.shared.postTransaction(transaction: transactionPost, completion: { result  in
                    switch result {
                    case .success(let transactionPost):
                        print("The following transaction has been sent: \(transactionPost.amount)" )
                    case .failure(let error):
                        print("An error occured \(error)")
                    }
                })
                
                self.getUserBalance()
                
                NotificationCenter.default.post( name: .updatedAmount , object: nil)
            }
        }
        
        let cancelAction = (UIAlertAction(title: "Cancel", style: .cancel, handler: { (pAction) in
            ac.dismiss(animated: true, completion: nil)}))
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}


    // MARK: - TableView Extension

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balance?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : CustomTransactionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTransactionTableViewCell else { fatalError() }
        
        guard let balance = balance else { return cell }
        
        let transaction         = balance.transactions.reversed().compactMap{($0)}[indexPath.row]
        let personalTrans       = personalTransactions.reversed()[indexPath.row]
        let personalTransFloat  = Float(personalTrans)
        let trannsactionIndex   = ((indexPath.row) - transactions.count) * -1
        
        
        let formatter           = DateFormatter()
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat    = "yyyy-MM-dd'T'H:mm:ss.SSS'Z'"
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        let convertedDate       = formatter.date(from: transaction.timestamp!)
        
        formatter.dateStyle     = .medium
        formatter.timeStyle     = .short
        formatter.timeZone      = .autoupdatingCurrent
        
        let dateString = formatter.string(from: convertedDate!)
        
        cell.amountLabel.text       = "Amount: \(transaction.amount)"
        cell.balanceLabel.text      = "Balance: \(personalTransFloat)"
        cell.fromAddressLabel.text  = "From: \(transaction.fromAddress ?? "Origin")"
        cell.toAddressLabel.text    = "To: \(transaction.toAddress!)"
        cell.timeStampLabel.text    = dateString
        
        cell.transactionNumberLabel.text = "Transaction: \(trannsactionIndex)"
        cell.hashNumberLabel.text        = "Txn Hash: 13094093829slj2923409"
        
        return cell
    }
}

extension Notification.Name {
    static let updatedAmount = Notification.Name("updatedAmount")
}



