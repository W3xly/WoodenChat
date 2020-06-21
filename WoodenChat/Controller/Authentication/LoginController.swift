//
//  LoginController.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.setDimensions(height: 220, width: 220)
        return iv
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: "envelope", textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: "lock",
                                  textField: passwordTextField)
    }()
    
    private let loginButton: AuthButton = {
        let btn = AuthButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return btn
    }()
    
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(placeholder: "Email", isSecure: false)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(placeholder: "Password", isSecure: true)
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let dontHaveAccountButton: AuthNavigationButton = {
        let button = AuthNavigationButton(text1: "Don't have an account?  ", text2: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        view.showLoader(true, withText: "Logging in")
        
        AuthService.logUserIn(withEmail: email, withPassword: password) { (result, error) in
            if let error = error {
                self.view.showLoader(false)
                self.showError(error.localizedDescription)
                return
            } else {
                self.view.showLoader(false)
                self.delegate?.authenticationComplete()
            }
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        configureBackgroundLayer()
        hideKeyboardWhenTappedAround()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}

//MARK: - AuthenticationControllerProtocol

extension LoginController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.35
        }
    }
}
