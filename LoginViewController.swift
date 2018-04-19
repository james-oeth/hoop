//
//  LoginViewController.swift
//  Hoop
//
//  Created by james oeth on 3/18/18.
//  Copyright © 2018 jamesOeth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    //create variables to save to
    var email = ""
    var userLoggedOut = false
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = MyVariables.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.borderColor = MyVariables.mainColor.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    lazy var skipLoginRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.mainColor
        button.setTitle("Skip Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(skipLogin), for: .touchUpInside)
        return button
    }()
    
    
    lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = MyVariables.backgroundColor
        button.setTitle("reset password", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(MyVariables.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        
        return button
    }()
    
    let emailView: UIView = {
        let v = UIView()
        v.backgroundColor = MyVariables.backgroundColor
        // v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var avaliableEmailImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.layer.cornerRadius = 5
        //image.layer.masksToBounds = true
        let origImage = UIImage(named: "x");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        image.image = tintedImage
        image.tintColor = UIColor.red
        image.alpha = 0
        return image
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func skipLogin(){
        //add skip login sheit
        FIRAuth.auth()?.signIn(withEmail: "guest@gmail.com", password: "guest1", completion: { (user, error) in
            if error != nil {
                print(error.debugDescription)
                if let code = error?.code {
                    print("here is the error code")
                    print(code)
                    if code == 17009 {
                        //incorrect password
                        print("password should be more than six characters")
                        self.view.addSubview(self.badPassword)
                        self.view.addSubview(self.resetPasswordButton)
                        self.setupBadPasswordWithReset()
                        self.badPassword.text = "Incorrect password"
                        self.removeBadEmail()
                        self.avaliableEmailImage.alpha = 0
                        
                    }
                    if code == 17011{
                        //incorrect email
                        print("email already in use")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "No account exhists for this email"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        self.removeBadPassword()
                    }
                    if code == 17008{
                        print("email already in use")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "Please enter correctly formatted email"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        self.removeBadPassword()
                    }
                    else{
                        //something is wrong
                    }
                }
                return
            }
            let homeView = GuestHomeViewController()
            self.navigationController?.viewControllers = [homeView]
            self.navigationController?.pushViewController(homeView, animated: true)
        })
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error.debugDescription)
                if let code = error?.code {
                    print("here is the error code")
                    print(code)
                    if code == 17009 {
                        //incorrect password
                        print("password should be more than six characters")
                        self.view.addSubview(self.badPassword)
                        self.view.addSubview(self.resetPasswordButton)
                        self.setupBadPasswordWithReset()
                        self.badPassword.text = "Incorrect password"
                        self.removeBadEmail()
                        self.avaliableEmailImage.alpha = 0
                        
                    }
                    if code == 17011{
                        //incorrect email
                        print("email already in use")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "No account exhists for this email"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        self.removeBadPassword()
                    }
                    if code == 17008{
                        print("email already in use")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "Please enter correctly formatted email"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        self.removeBadPassword()
                    }
                    else{
                        //something is wrong
                    }
                }
                return
            }
            let homeView = HomeViewController()
            self.navigationController?.viewControllers = [homeView]
            self.navigationController?.pushViewController(homeView, animated: true)
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        UIView.setAnimationsEnabled(true)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error?.code ?? "There was an error")
                if let code = error?.code {
                    if code == 17007{
                        print("email already in use")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "This email is already in use"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        
                    }
                        
                    else if code == 17008{
                        print("invalid email")
                        self.view.addSubview(self.badEmail)
                        self.setupBadEmail()
                        self.badEmail.text = "Please enter a valid email"
                        let origImage = UIImage(named: "x");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.avaliableEmailImage.image = tintedImage
                        self.avaliableEmailImage.tintColor = UIColor.red
                        self.avaliableEmailImage.alpha = 0.5
                        
                    }
                        
                    else{
                        print("email is okay")
                        if self.avaliableEmailImage.alpha != 0{
                            let origImage = UIImage(named: "check");
                            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            self.avaliableEmailImage.image = tintedImage
                            self.avaliableEmailImage.tintColor = UIColor.green
                            self.avaliableEmailImage.alpha = 0.5
                            self.removeBadEmail()
                        }
                    }
                    if code == 17010{
                        print("user has made too many requests")
                        self.view.addSubview(self.badPassword)
                        self.setupBadPassword()
                        self.badPassword.text = "Too many tries, wait and try again"
                    }
                    
                    if code == 17026{
                        print("password should be more than six characters")
                        self.view.addSubview(self.badPassword)
                        self.setupBadPassword()
                        self.badPassword.text = "Password must be more than 6 characters"
                    }
                        
                    else{
                        self.removeBadPassword()
                        
                    }
                    
                }
                return
                
            }
            
            guard let uid = user?.uid else {
                return
            }
            let ref = FIRDatabase.database().reference()
            let usersReference = ref.child("users").child(uid)
            let time = Date(timeIntervalSinceReferenceDate: NSDate.timeIntervalSinceReferenceDate)
            let timeNum = Double(time.timeIntervalSinceReferenceDate)
            let values = [ "id": uid, "email": email, "timeAccountMade" : timeNum ] as [String : Any]
            usersReference.updateChildValues(values as [AnyHashable: Any], withCompletionBlock: { (err, ref) in
                //there was an error
                if err != nil{
                    print(err.debugDescription)
                    return
                }
            })
            DispatchQueue.main.async {
                let mainView = HomeViewController()
                self.navigationController?.viewControllers = [mainView]
                self.navigationController?.pushViewController(mainView, animated: true)
            }
        })
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.layer.masksToBounds = true
        tf.autocorrectionType = .no
        tf.tag = 1
        return tf
    }()
    
    let badEmail:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textAlignment = .left
        l.textColor = UIColor.lightGray
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let badPassword:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 12)
        l.textAlignment = .left
        l.textColor = UIColor.lightGray
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = MyVariables.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        tf.isSecureTextEntry = true
        tf.tag = 2
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bball")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = MyVariables.mainColor
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    var segmentedControllerBottomAnchor: NSLayoutConstraint?
    var loginRegisterButtonTopAnchor: NSLayoutConstraint?
    
    func removeBadEmail(){
        badEmail.removeFromSuperview()
        segmentedControllerBottomAnchor?.isActive = false
        segmentedControllerBottomAnchor = loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12)
        segmentedControllerBottomAnchor?.isActive = true
        
    }
    
    func removeBadPassword(){
        badPassword.removeFromSuperview()
        resetPasswordButton.removeFromSuperview()
        loginRegisterButtonTopAnchor?.isActive = false
        loginRegisterButtonTopAnchor = loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12)
        loginRegisterButtonTopAnchor?.isActive = true
    }
    
    
    func setupBadEmail(){
        segmentedControllerBottomAnchor?.isActive = false
        badEmail.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 2).isActive = true
        badEmail.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:  10).isActive = true
        badEmail.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        badEmail.heightAnchor.constraint(equalToConstant: 25).isActive = true
        segmentedControllerBottomAnchor = loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: badEmail.topAnchor)
        segmentedControllerBottomAnchor?.isActive = true
        
    }
    
    func setupBadPassword(){
        loginRegisterButtonTopAnchor?.isActive = false
        badPassword.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 2).isActive = true
        badPassword.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        badPassword.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        badPassword.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loginRegisterButtonTopAnchor = loginRegisterButton.topAnchor.constraint(equalTo: badPassword.bottomAnchor)
        loginRegisterButtonTopAnchor?.isActive = true
    }
    
    func setupBadPasswordWithReset(){
        loginRegisterButtonTopAnchor?.isActive = false
        badPassword.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 2).isActive = true
        badPassword.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        badPassword.rightAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        badPassword.heightAnchor.constraint(equalToConstant: 25).isActive = true
        resetPasswordButton.leftAnchor.constraint(equalTo: badPassword.rightAnchor).isActive = true
        resetPasswordButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 2).isActive = true
        resetPasswordButton.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        resetPasswordButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loginRegisterButtonTopAnchor = loginRegisterButton.topAnchor.constraint(equalTo: badPassword.bottomAnchor)
        loginRegisterButtonTopAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [self]
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //add subview of the fb login button
        view.backgroundColor = MyVariables.backgroundColor
        //view.backgroundColor = UIColor(r: 255, g: 137, b: 103)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(skipLoginRegisterButton)
        setupEmailView()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupProfileImageView()
        setupSkipLoginView()
        
    }
    
    func setupSkipLoginView(){
        skipLoginRegisterButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 10).isActive = true
        skipLoginRegisterButton.leftAnchor.constraint(equalTo: loginRegisterButton.leftAnchor, constant: 0).isActive = true
        skipLoginRegisterButton.rightAnchor.constraint(equalTo: loginRegisterButton.rightAnchor, constant: 0).isActive = true
        skipLoginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true


    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
        
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        if title == "Login"{
            print("login button tapped")
            avaliableEmailImage.alpha = 0
            removeBadEmail()
            removeBadPassword()
        }
        else{
            removeBadEmail()
            removeBadPassword()
        }
    }
    
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControllerBottomAnchor = loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12)
        segmentedControllerBottomAnchor?.isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupEmailView(){
        emailView.addSubview(emailTextField)
        emailView.addSubview(avaliableEmailImage)
        emailTextField.leftAnchor.constraint(equalTo: emailView.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailView.topAnchor).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: emailView.rightAnchor, constant: -50).isActive = true
        avaliableEmailImage.topAnchor.constraint(equalTo: emailView.topAnchor, constant: 5).isActive = true
        avaliableEmailImage.bottomAnchor.constraint(equalTo: emailView.bottomAnchor, constant:  -5).isActive = true
        avaliableEmailImage.rightAnchor.constraint(equalTo: emailView.rightAnchor, constant:  -5).isActive = true
        avaliableEmailImage.leftAnchor.constraint(equalTo: emailTextField.rightAnchor, constant: 5).isActive = true
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(emailView)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        emailView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        emailView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButtonTopAnchor = loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12)
        loginRegisterButtonTopAnchor?.isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            passwordTextField.becomeFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
        }
        return true
        
    }
    
    func handlePasswordReset(){
        if let email = emailTextField.text{
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    AppDelegate.getAppDelegate().showMessage("Password Reset Sent To Email")
                })
            })
        }
    }
}
