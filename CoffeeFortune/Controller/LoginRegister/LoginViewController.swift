//
//  FirstViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 9.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import SCLAlertView

class LoginViewController: UIViewController {
    
    //MARK: - Variables
    
    //MARK: - IBOutlets
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var emailBtn: UIButton!
    //MARK: - IBActions
    @IBAction func emailBtnAction(_ sender: UIButton) {
        gotoRegisterVC(isTrue: false)
    }
    @IBAction func registerBtnAction(_ sender: UIButton) {
        gotoRegisterVC(isTrue: true)
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        let permission = ["public_profile"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permission) { (user, error) in
            self.activityIndicator.startAnimating()
            if error == nil {
                if let user = user {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    if user.isNew { // new user, add to remote db
                        var incoming_facebook : NSDictionary?
                        if (FBSDKAccessToken.current() != nil ) {
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, email"])?.start(completionHandler: { (connection, result, error) in
                                if error == nil { //if incoming data is successful
                                    incoming_facebook = (result as! NSDictionary)
                                    if let incoming_facebook = incoming_facebook {
                                        //eamil
                                        if incoming_facebook.object(forKey: "email") != nil {
                                            user["email"] = incoming_facebook.object(forKey: "email")
                                        }
                                        
                                        if incoming_facebook.object(forKey: "first_name") != nil {
                                            user["name"] = incoming_facebook.object(forKey: "first_name")
                                        }
                                        
                                        if incoming_facebook.object(forKey: "last_name") != nil {
                                            user["surname"] = incoming_facebook.object(forKey: "last_name")
                                        }
                                    }
                                    
                                    //give 10 credits to the user during initial registration
                                    user["credits"] = 10
                                    let  acl = PFACL()
                                    acl.hasPublicReadAccess = true
                                    acl.hasPublicWriteAccess = true
                                    
                                    user.acl = acl
                                    
                                    user.saveInBackground(block: { (success, error) in
                                        if error == nil {
                                            self.redirect()
                                        } else {
                                            self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                                        }
                                    })
                                }
                            })
                        }
                    } else { // old user, send by redirect
                        self.redirect() //optional
                    }
                }
            } else {
                self.activityIndicator.stopAnimating()
                SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    //MARK: - statements
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func gotoRegisterVC(isTrue:Bool) {
        let stoaryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:RegisterViewController = stoaryboard.instantiateViewController(withIdentifier: "RegisterStoaryboardID") as! RegisterViewController
        vc.isRegistering = isTrue
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUser()
    }
    
    func checkUser() {
        if PFUser.current() != nil {
            redirect()
        }
    }
    
    func redirect() {
        let stoaryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stoaryboard.instantiateViewController(withIdentifier: "TabBarStoaryboardID") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
}

