//
//  LoginTextField.swift
//  QuoteDubDub
//
//  Created by Erik Martin on 4/10/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 7, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    
}
