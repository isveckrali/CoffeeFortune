//
//  SecondViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 9.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    
    //MARK: - Variables
    
    @IBOutlet var table: UITableView!
    
    //MARK: - IBOutlets
    
    
    //MARK: - Statememts
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.table.tableFooterView = UIView()
    }


    //MARK: - Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        switch indexPath.row {
        case 0:
            cell.menuImage.image = UIImage(named: "privacypolicy")
            cell.menuText.text = "Privacy Policy"
            break
        case 1:
            cell.menuImage.image = UIImage(named: "termsofuse")
            cell.menuText.text = "Terms of use"
            break
        case 2:
            cell.menuImage.image = UIImage(named: "logout")
            cell.menuText.text = "Logout"
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            openURL("http://thecoderdream.com/category/java/javase/")
            break
        case 1:
            openURL("https://www.linkedin.com/in/mehmet-can-seyhan-303b88123/")
            break
        case 2: //logout from parse
           // openURL("https://www.instagram.com/mehmet_can_seyhan/")
            if PFUser.current() != nil {
                PFUser.logOutInBackground { (error) in
                    if error != nil {
                        SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                    } else {
                        self.redirect()
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    //MARK: - Functions
    
    func openURL(_ url : String) {
        print(url)
    }
    
    func redirect() {
        let stoaryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stoaryboard.instantiateViewController(withIdentifier: "LoginStoaryboardID") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
}

