//
//  JWButton.swift
//  JobCoin Wallet
//
//  Created by Jerrick Warren on 9/5/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import UIKit

class JWButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = #colorLiteral(red: 0.3231648207, green: 0.7656773329, blue: 0.9433547854, alpha: 1)
        layer.cornerRadius  = frame.size.height / 2
        tintColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
