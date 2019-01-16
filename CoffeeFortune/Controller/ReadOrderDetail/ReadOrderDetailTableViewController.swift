//
//  ReadOrderDetailTableViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 16.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit

class ReadOrderDetailTableViewController: UITableViewController {

    //MARK: - Variables
    
    var selectedOrder:OrderModel?
    
    
    
    //MARK: - IBActions
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion:    nil)
    }
    //MARK: - Statements
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadOrderDetailCloseCell", for: indexPath) as! ReadOrderDetailCloseTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReadOrderDetailCell", for: indexPath) as!  ReadOrderDetailTableViewCell
            if let selectedOrder = selectedOrder {
                cell.detailText.text = selectedOrder.text
            }
            return cell
        }
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
