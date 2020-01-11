//
//  LoginViewController.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 10/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.toggleState(on: false)
        toggleIndicator(active: false)
    }

    @IBAction func registerBtnClicked(_ sender: UIButton) {
        UIApplication.shared.open(NetworkClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        if !emailField.text!.isEmpty && !passwordField.text!.isEmpty {
            loginBtn.toggleState(on: true)
        } else {
            loginBtn.toggleState(on: false)
        }
    }
    
    func toggleIndicator(active: Bool) {
        if active {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    @IBAction func loginBtnClicked(_ sender: UIButton) {
        setLoggingIn(true)
        NetworkClient.login(username: emailField.text ?? "", password: passwordField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            passwordField.text = ""
            performSegue(withIdentifier: "loginSegue", sender: nil)
        } else {
            (error?.localizedDescription ?? "").showError()
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        toggleIndicator(active: loggingIn)
        emailField.isEnabled = !loggingIn
        passwordField.isEnabled = !loggingIn
        loginBtn.toggleState(on: !loggingIn)
        registerBtn.toggleState(on: !loggingIn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
