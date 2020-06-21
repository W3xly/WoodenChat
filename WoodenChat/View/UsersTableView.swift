//
//  ConversationsTableView.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ConversationCell"

final class ConversationsTableView: UITableView {
    
    //MARK: - Properties
    
    private var users: [User] = []
    private var conversations: [Conversation] = []
    
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
       // showLoader(true)
        Service.fetchConversations { conversations in
            self.conversations = conversations
            self.reloadData()
        }
    }
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        rowHeight = 80
        register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableFooterView = UIView() // Nevrací prázdné Cells
        delegate = self
        dataSource = self
    }
}

//MARK: - UITableViewDelegate

extension ConversationsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let user = conversations[indexPath.row].user
        //        showChatController(forUser: user)
        print(indexPath.row)
    }
}

//MARK: - UITableViewDataSource

extension ConversationsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //            return conversations.count
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].message.text
        cell.textLabel?.textColor = .black
        return cell
    }
}
