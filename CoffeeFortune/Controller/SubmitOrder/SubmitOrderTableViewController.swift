//
//  SubmitOrderTableViewController.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 15.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse
import ActionSheetPicker_3_0
import SCLAlertView

var playerId = ""
class SubmitOrderTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    //MARK: - Variables
    var selectedOrderModel: OrderModel?
    var imagePicker = UIImagePickerController()

    var senderTag:Int = 0
    //MARK: - IBActions
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameChangedAction(_ sender: UITextField) {
            if sender.text != "" {
            selectedOrderModel?.name = sender.text
            }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func subjectChangedAction(_ sender: UIButton) {
        
        ActionSheetMultipleStringPicker.show(withTitle: "Choose Topic", rows: [
            ["Love", "Work", "Health"],
            ], initialSelection: [selectedOrderModel?.subject ?? 0], doneBlock: {
                picker, indexes, values in
                if let index = indexes?[0] as? Int {
                self.selectedOrderModel?.subject = index
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? SubmitOrder3TableViewCell {
                        if let name = values as? Array<String> {
                        cell.subjectButton.setTitle(name.first, for: .normal)
                        }
                    }
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
    }
    
    @IBAction func uploadImageAction(_ sender: UIButton) {
        
        senderTag = sender.tag
        self.present(self.imagePicker, animated: true, completion: nil)
       
        
        
        
    }
    
    //Photo selection option method
    func chooseFotoCondition() {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        self.imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              if senderTag == 0 { //first image
             if let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))  as? SubmitOrder1TableViewCell {
             cell.image1Button.setBackgroundImage(image, for: .normal)
             }
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                
                let imageObject = PFObject(className: "Images")
                imageObject["image"] = PFFile(name: "image1.png", data: imageData)
                    imageObject.saveInBackground { (success, error) in
                        if error == nil {
                           self.selectedOrderModel?.image1 = imageObject.objectId
                        }
                    }
                }
              } else if senderTag == 1 { //Second image
             if let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))  as? SubmitOrder1TableViewCell {
             cell.image2Button.setBackgroundImage(image, for: .normal)
             }
                
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    
                    let imageObject = PFObject(className: "Images")
                    imageObject["image"] = PFFile(name: "image2.png", data: imageData)
                    imageObject.saveInBackground { (success, error) in
                        if error == nil {
                            self.selectedOrderModel?.image2 = imageObject.objectId
                        }
                    }
                }
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitOrderAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let user = PFUser.current() {
            user.fetchInBackground { (fetchedUser, error) in
                if error == nil {
                    if let fetchedUser = fetchedUser {
                       let credits = fetchedUser["credits"] as! Int
                        if credits < 10 {
                            SCLAlertView().showError("Error", subTitle: "Your credits amount is less. Please buy credits")
                        } else {
                            self.submmitOrder()
                        }
                    }
                } else {
                    SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                }
            }
        }
        
    }
    
    
    //MARK: - Statements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseFotoCondition()
        
        self.tableView.tableFooterView = UIView()
        
        selectedOrderModel = OrderModel()
        selectedOrderModel?.userId = PFUser.current()?.objectId
        selectedOrderModel?.subject = 0
        selectedOrderModel?.status = 0
        selectedOrderModel?.text = ""
    
    }
    
   

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 110
        } else {
            return 50
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder0Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder1Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder2Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder3Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitOrder4Cell", for: indexPath)
            
            // Configure the cell...
            
            return cell
        }
       
    }
    
    //MARK: - Functions

    func submmitOrder() {
        if let model = selectedOrderModel {
            let params = [
                "userId" : model.userId!,
                "subject" : model.subject!,
                "status" : model.status!,
                "image1" : model.image1 ?? "",
                "image2" : model.image2 ?? "",
                "name" : model.name!,
                "playerId" : playerId
                ] as [String : Any]
            PFCloud.callFunction(inBackground: "submitOrderCloud", withParameters: params) { (success, error) in
                if error == nil {
                    SCLAlertView().showSuccess("Successful", subTitle: "Your coffee fortune sent successfully")
                } else {
                    SCLAlertView().showError("Error", subTitle: (error?.localizedDescription)!)
                }
            }
        }
    }
}
