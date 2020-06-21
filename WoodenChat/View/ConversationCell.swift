//
//  ConversationCell.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 19/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//


import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()

    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray        
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 4
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                     paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor,
                              paddingTop: 20, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)

        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text

        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)


    }
}
