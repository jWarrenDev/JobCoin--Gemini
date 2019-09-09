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
    
    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var hashNumberLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.layer.backgroundColor = #colorLiteral(red: 0.5775073171, green: 0.7880946398, blue: 0.4146306813, alpha: 1)
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.5
        self.tintColor = .white
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
        cellView.layer.cornerRadius = 18
        cellView.layer.masksToBounds = true
       
        colorView.layer.masksToBounds = true
        colorView.backgroundColor = #colorLiteral(red: 0.2545096278, green: 0.4599397182, blue: 0.0195639655, alpha: 1)
        colorView.layer.cornerRadius = 14
        colorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
    }
}
