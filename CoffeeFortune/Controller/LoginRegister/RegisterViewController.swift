//
//  RegisterViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 9.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse


class RegisterViewController: UIViewController {
    
    //MARK: - Variables
    var isRegistering = true
    
    //MARK: - IBOutlets
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginRegisterBtn: UIButton!
    @IBOutlet var topLbl: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - IBActions
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginRegisterAction(_ sender: UIButton) {
        if isRegistering {
            register()
        } else {
            login()
        }
        self.view.endEditing(true)
    }
    //MARK: - Statements
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cheangeText()
        // Do any additional setup after loading the view.
    }
    
    func cheangeText() {
        if isRegistering {
            topLbl.text = "Login With Email"
            loginRegisterBtn.setTitle("Register", for: .normal)
        }
    }
    
    //user is going to register in there
    func register() {
        self.view.endEditing(true)
        if ((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            SCLAlertView().showError("Error", subTitle: "Text fields can not be empty")
        } else {
            activityIndicator.startAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if let email = emailTextField.text, let password = passwordTextField.text {
            let user = PFUser()
            user.username = email.lowercased()
            user.email = email.lowercased()
            user.password = password
                
                //give 10 credit to user in first registering
                user["credits"] = 10
            
                
                let acl = PFACL()
                acl.hasPublicWriteAccess = true
                acl.hasPublicReadAccess = true
                user.acl = acl
                user.signUpInBackground { (success, error) in
                    if error != nil {
                        //print(error?.localizedDescription)
                        SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.redirect()
                    }
                }
            }
        }
        
    }
    
    //user login in there
    func login() {
        if ((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!) {
            SCLAlertView().showError("Error", subTitle: "Text Fields can not be empty").close()
            
        } else {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //starting login actions
            PFUser.logInWithUsername(inBackground: (emailTextField.text?.lowercased())!, password: (passwordTextField.text?.lowercased())!) { (user, error) in
                self.activityIndicator.stopAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIApplication.shared.endIgnoringInteractionEvents()
                if error == nil {
                    self.redirect() //user's login is successfully go to next page
                } else {
                    SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }

    func redirect() {
        let stoaryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stoaryboard.instantiateViewController(withIdentifier: "TabBarStoaryboardID") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkUser() {
        if PFUser.current() != nil {
            redirect()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Functions

}
