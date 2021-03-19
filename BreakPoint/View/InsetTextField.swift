//
//  InsetTextField.swift
//  BreakPoint
//
//  Created by Mohamed on 1/20/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit

class InsetTextField: UITextField, UITextFieldDelegate {
    
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.delegate = self
        subView()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.inset(by: padding)
    }
    
    func subView() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    

}
