//
//  AuthNavigationButton.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

final class AuthNavigationButton: UIButton {
    
    private let text1: String = ""
    private let text2: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text1: String, text2: String) {
        super.init(frame: .zero)
        let attributedTitle = NSMutableAttributedString(string: text1, attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.white])
        attributedTitle.append(NSMutableAttributedString(string: text2, attributes: [.font: UIFont.boldSystemFont(ofSize: 17), .foregroundColor: UIColor.white]))
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
