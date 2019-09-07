//
//  CustomTransactionTableViewCell.swift
//  JobCoin Wallet
//
//  Created by Jerrick Warren on 9/5/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import UIKit

class CustomTransactionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6892092228, blue: 0.9265916348, alpha: 1)
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.5
        self.tintColor = .white
        cellView.layer.cornerRadius = 18
        cellView.layer.masksToBounds = true
        cellView.layer.shadowOpacity = 0.5
    }
}
