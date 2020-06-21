//
//  ConversationsController.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit
import Firebase

final class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    private let conversationsView = ConversationsTableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.3293147208, green: 0.2126797473, blue: 0.139816304, alpha: 1)
        button.setDimensions(height: 56, width: 56)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(showNewMessageController), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    //MARK: - Selectors
    
    @objc func handleShowProfile() {
        let controller = ProfileController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showNewMessageController() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in. Present login screen here.")
            presentLoginScreen()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            conversationsView.clearView()
            presentLoginScreen()
            print("DEBUG: user signed out..")
        }
        catch {
            print("DEBUG: Error signing out.")
        }
    }
    
    //MARK: - Helpers
    
    private func showChatController(forUser user: User) {
        navigationItem.title = ""
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    private func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func configureUI() {
        let profileImage = UIImage(systemName: "person.fill")
        let profileButton = UIBarButtonItem(image: profileImage, style: .done, target: self, action: #selector(handleShowProfile))
        
        navigationItem.leftBarButtonItem = profileButton
        
        view.addSubview(conversationsView)
        conversationsView.frame = view.frame
        conversationsView.conversationDelegate = self
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                paddingBottom: 16, paddingRight: 24)
    }
}

//MARK: - NewMessageControllerDelegate

extension ConversationsController: NewMessageControllerDelegate {
    
    func passUser(_ controller: NewMessageController, wantsToStartChatWitch user: User) {
        dismiss(animated: true, completion: nil)
        showChatController(forUser: user)
    }
}

//MARK: - ConversationsTableViewDelegate

extension ConversationsController: ConversationsTableViewDelegate {
    
    func passUser(_ user: User) {
        showChatController(forUser: user)
    }
}

//MARK: - AuthenticationDelegate

extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        conversationsView.fetchConversations()
        print("DEBUG: Auth complete in Conversation Controller..")
    }
}

//MARK: - ProfileControllerDelegate

extension ConversationsController: ProfileControllerDelegate {
    
    func logoutUser(_ controller: ProfileController) {
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
}
