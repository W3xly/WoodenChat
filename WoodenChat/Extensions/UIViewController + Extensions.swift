//
//  UIViewController + Extensions.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground() // opaque = neprůhledný
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]
        appearance.backgroundImage = UIImage(named: "darkBackground")
        
        if let navBar = navigationController?.navigationBar {
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            
            navBar.prefersLargeTitles = prefersLargeTitles
            navBar.tintColor = UIColor(cgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            navBar.isTranslucent = true
            navBar.overrideUserInterfaceStyle = .dark
            navigationItem.title = title
            
        }
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }    
    
    func configureBackgroundLayer(){
        let background = UIImage(named: "authBackground")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.image = background
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
}
