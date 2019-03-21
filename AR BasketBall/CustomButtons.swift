//
//  CustomButtons.swift
//  AR BasketBall
//
//  Created by Haitham Abdel Wahab on 3/7/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit

class CustomButtons: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        customButtons()
        
    }
    
    func customButtons() {
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0 //2 pixels
        layer.borderColor = UIColor.white.cgColor
        
    }
}
