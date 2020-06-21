//
//  MessageCell.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 18/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var message: Message? {
        didSet { configure() }
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        // left bubble
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        // right bubble
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        left: bubbleContainer.leftAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingTop: 4,
                        paddingLeft: 12,
                        paddingBottom: 4,
                        paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let message = message else { return }
        
        let viewModel = MessageViewModel(message: message)
        
        textView.text = message.text
        textView.textColor = viewModel.messageTextColor
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
