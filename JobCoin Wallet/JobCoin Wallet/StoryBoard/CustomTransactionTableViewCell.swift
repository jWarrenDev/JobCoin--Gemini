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

        self.layer.backgroundColor = #colorLiteral(red: 0, green: 0.6892092228, blue: 0.9265916348, alpha: 1)
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.5
        self.tintColor = .white
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellView.layer.borderWidth = 2
        cellView.layer.cornerRadius = 18
        cellView.layer.masksToBounds = false
        cellView.layer.shadowOpacity = 5
        
        colorView.layer.masksToBounds = true
        colorView.backgroundColor = .darkGray
        colorView.layer.cornerRadius = 18
        colorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 10, height: 10)
        cellView.layer.shadowRadius = 2
        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = UIBezierPath(roundedRect: colorView.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 50, height: 40)).cgPath
//        colorView.layer.mask = maskLayer
    }
}
