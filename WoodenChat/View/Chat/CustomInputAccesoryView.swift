//
//  CustomInputAccesoryView.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 18/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

protocol CustomInputAccesoryViewDelegate: class {
    func passMessage(_ inputView: CustomInputAccesoryView, wantsToSend message: String)
}

final class CustomInputAccesoryView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CustomInputAccesoryViewDelegate?
    
    private let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 5
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 0.3293147208, green: 0.2126797473, blue: 0.139816304, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8437985778, green: 0.6534314752, blue: 0.4057908356, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        button.setDimensions(height: 50, width: 50)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero // setup content size based on its content
    }
    
    //MARK: - Selectors
    
    @objc func handleSendMessage() {
        guard let message = messageInputTextView.text else { return }
        if message != "" {
        delegate?.passMessage(self, wantsToSend: message)
        }
    }
    
    @objc func handleTextInputChange() {
        let isEmpty = messageInputTextView.text.isEmpty
        placeholderLabel.isHidden = isEmpty ? false : true
    }
    
    //MARK: - Helpers
    
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
    private func configureUI() {
        autoresizingMask = .flexibleHeight
        addBackground(imageName: "darkBackground")
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor,
                                    bottom: safeAreaLayoutGuide.bottomAnchor,
                                    right: sendButton.leftAnchor,
                                    paddingTop: 12, paddingLeft: 12,
                                    paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 8)
        placeholderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
}
