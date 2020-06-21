//
//  AuthButton.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

final class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = #colorLiteral(red: 0.7892646194, green: 0.5749529004, blue: 0.298653245, alpha: 1)
        setTitleColor(.white, for: .normal)
        setHeight(height: 50)
        // Disable until form is filled
        alpha = 0.35
        isEnabled = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
