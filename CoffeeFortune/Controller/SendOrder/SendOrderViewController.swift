//
//  SendOrderViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 14.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse

class SendOrderViewController: UIViewController {

    
    //MARK: -  Variables
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var creditsText: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - IBActions
    
    @IBAction func goSubmitOrderAction(_ sender: Any) {
        let stoaryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = stoaryboard.instantiateViewController(withIdentifier: "SubmitOrderStoaryboardID") as! SubmitOrderTableViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.endIgnoringInteractionEvents()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func increaseCreditsAction(_ sender: UIButton) {
        if let user = PFUser.current() {
            activityIndicator.startAnimating()
            user.incrementKey("credits", byAmount: 10)
            user.saveEventually { (success, error) in
                self.activityIndicator.stopAnimating()
                if error == nil {
                self.getUserData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserData()
    }
    
    // MARK: - Table view data source
    func getUserData() {
        if let user = PFUser.current() {
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil {
                    if let fetchedUser = fetchedUser {
                    if let credits = fetchedUser["credits"] as? Int {
                    self.creditsText.setTitle("\(credits.description) Credit", for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - Functions
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
