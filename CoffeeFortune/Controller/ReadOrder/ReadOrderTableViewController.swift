//
//  ReadOrderTableViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 16.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import UIScrollView_InfiniteScroll

class ReadOrderTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Variables
    var allOrders = [OrderModel]();
    var currentPage:Int = 0
    var allDataDownloaded = false
    //MARK: - IBOutlests
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        self.tableView.tableFooterView = UIView()
        if let user = PFUser.current() {
            if let userId = user.objectId {
                addInfinitiveScroll(userId: userId)
                //getOrdersInfo(self.userId)
            }
        }
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allOrders.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReadOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReadOrderCell") as! ReadOrderTableViewCell
        cell.statusText.text = allOrders[indexPath.row].status == 0 ? "Your coffee fortune is preparing" : "Your coffee fortune is ready"
        if let date = allOrders[indexPath.row].createdAt {
        cell.dateText.text = date.description
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allOrders[indexPath.row].status == 0 {
            SCLAlertView().showWait("Wait", subTitle: "Your coffee fortune is not ready. Please wait for your coffee fortune to be prepared.")
        } else {
            let stoaryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = stoaryboard.instantiateViewController(withIdentifier: "ReadOrderDetailStoaryboardID") as! ReadOrderDetailTableViewController
            vc.selectedOrder = allOrders[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Functions
    
    func addInfinitiveScroll(userId:String) {
        if self.allDataDownloaded == false {
            self.getOrdersInfo(userId)
        }
        
        tableView.finishInfiniteScroll()
        tableView.setShouldShowInfiniteScrollHandler { (table) -> Bool in
            return !(self.allDataDownloaded)
        }
    }

    func getOrdersInfo(_ userId:String) {
        let query = PFQuery(className: "Orders")
        query.whereKey("user", equalTo: PFObject.init(withoutDataWithClassName: "_User", objectId: userId))
        query.limit = 8
        query.skip = currentPage * 8
        query.order(byDescending: "createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            self.activityIndicator.stopAnimating()
           if error == nil {
                if let objects = objects {
                    for object in objects {

                        var order = OrderModel()
                        order.text = object["text"] as? String
                        order.status = object["status"] as? Int
                        order.subject = object["subject"] as? Int
                        order.createdAt = object.createdAt
                       self.allOrders.append(order)
                    }
                    self.tableView.reloadData()
                    self.currentPage += 1
                    
                    if objects.count < 8 {
                        self.allDataDownloaded = true
                    }
                }
            } else {
                print("Occured Error \(error?.localizedDescription)")
            }
        }
        
    }
}
