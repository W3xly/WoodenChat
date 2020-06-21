//
//  ProfileController.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 19/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

protocol ProfileControllerDelegate: class {
    func logoutUser(_ controller: ProfileController)
}

final class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: ProfileControllerDelegate?
    
    private let dismissButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        btn.tintColor = .white
        btn.imageView?.setDimensions(height: 25, width: 22)
        return btn
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 200, width: 200)
        iv.layer.cornerRadius = 200 / 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setDimensions(height: 50, width: 200)
        btn.backgroundColor = #colorLiteral(red: 0.8437985778, green: 0.6534314752, blue: 0.4057908356, alpha: 1)
        btn.setTitle("Log Out", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.3293147208, green: 0.2126797473, blue: 0.139816304, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        delegate?.logoutUser(self)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    //MARK: - Helpers
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        view.showLoader(true)
        Service.fetchUser(withUid: uid) { user in
            self.fullnameLabel.text = user.fullname
            self.usernameLabel.text = "@\(user.username)"
            self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
            self.view.showLoader(false)
        }
    }
    
    private func configureUI() {
        configureBackgroundLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
        
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: view.topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 10
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        stack.centerX(inView: view)
        
        view.addSubview(logoutButton)
        logoutButton.anchor(top: stack.bottomAnchor, paddingTop: 80)
        logoutButton.centerX(inView: view)
    }
}
