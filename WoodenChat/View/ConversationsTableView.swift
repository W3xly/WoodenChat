//
//  ConversationsTableView.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

protocol ConversationsTableViewDelegate: class {
    func passUser(_ user: User)
}

final class ConversationsTableView: UITableView {
    
    //MARK: - Properties
    
    private var conversations = [Conversation]()
    
    weak var conversationDelegate: ConversationsTableViewDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureUI()
        fetchConversations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    
    func fetchConversations() {
        showLoader(true)
        Service.fetchConversations { conversations in
            self.conversations = conversations
            self.reloadData()
        }
        showLoader(false)
    }
    
    //MARK: - Helpers
    
    func clearView() {
        conversations = []
        reloadData()
    }
    
    private func configureUI() {
        backgroundColor = .white
        rowHeight = 80
        register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableFooterView = UIView()
        delegate = self
        dataSource = self
    }
}

//MARK: - UITableViewDelegate

extension ConversationsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = conversationDelegate else { return }
        let user = conversations[indexPath.row].user
        delegate.passUser(user)
        print(indexPath.row)
    }
}

//MARK: - UITableViewDataSource

extension ConversationsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.selectionStyle = .none
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}
