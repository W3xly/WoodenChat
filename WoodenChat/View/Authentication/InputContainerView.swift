//
//  InputContainerView.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

final class InputContainerView: UIView {
    
    init(image: String, textField: UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: image)
        iv.tintColor = UIColor(cgColor: #colorLiteral(red: 0.8431372549, green: 0.6549019608, blue: 0.4039215686, alpha: 1))
        iv.alpha = 0.87
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 26, width: 30)
        
        addSubview(textField) // emailTextField můžu přidat jen díky lazy variable
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8)
        
        backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.8437985778, green: 0.6534314752, blue: 0.4057908356, alpha: 1)).withAlphaComponent(0.4)
        layer.cornerRadius = 5
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
