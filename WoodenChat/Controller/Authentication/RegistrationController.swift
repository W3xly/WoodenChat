//
//  RegistrationController.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var emailContainerView = InputContainerView(image: "envelope", textField: emailTextField)
    private lazy var fullNameContainerView = InputContainerView(image: "person.fill", textField: fullNameTextField)
    private lazy var userNameContainerView = InputContainerView(image: "person", textField: userNameTextField)
    private lazy var passwordContainerView = InputContainerView(image: "lock", textField: passwordTextField)
    
    private let emailTextField = AuthTextField(placeholder: "Email", isSecure: false)
    private let fullNameTextField = AuthTextField(placeholder: "Full Name", isSecure: false)
    private let userNameTextField = AuthTextField(placeholder: "Username", isSecure: false)
    private let passwordTextField = AuthTextField(placeholder: "Password", isSecure: true)
    
    //MARK: - BUTTON SIGN UP
    
    private let registrationButton: AuthButton = {
        let btn = AuthButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return btn
    }()
    
    private let alreadyHaveAccountButton: AuthNavigationButton = {
        let button = AuthNavigationButton(text1: "Already have an account?  ", text2: "Log In")
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Selectors
    
    @objc func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        view.showLoader(true, withText: "Signing You Up")
        
        let registrationCredentials = RegistrationCredentials(email: email, password: password,
                                                              fullname: fullname, username: username,
                                                              profileImage: profileImage)
        
        AuthService.createUser(credentials: registrationCredentials) { error in
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
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        }
        checkFormStatus()
    }
    //
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y = -100
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        configureBackgroundLayer()
        hideKeyboardWhenTappedAround()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                                                   passwordContainerView,
                                                   registrationButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        profileImage = image.sameAspectRation(newHeight: 200)
        plusPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - AuthenticationControllerProtocol

extension RegistrationController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            registrationButton.isEnabled = true
            registrationButton.alpha = 1
        } else {
            registrationButton.isEnabled = false
            registrationButton.alpha = 0.35
        }
    }
}

//MARK: - AuthenticationDelegate

extension RegistrationController: AuthenticationDelegate {
    func authenticationComplete() {
        self.dismiss(animated: true, completion: nil)
    }
}
