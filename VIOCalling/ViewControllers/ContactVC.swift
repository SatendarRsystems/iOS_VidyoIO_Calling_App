//
//  ContactVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 26/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log
import Alamofire
import AlamofireImage


class ContactVC: UITableViewController {
    
    var arrContacts: [Contact]  = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     A method to initialize basic view of this screen.
     */
    func initView() {
        self.requesGetContacts()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrContacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell

        // Configure the cell...
        let contact = arrContacts[indexPath.row]
        cell.lblName.text = contact.name
        
        if let url = URL(string: contact.profilePic!) {
            cell.imgContact.af_setImage(withURL: url)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? ContactCell, let indexPath = self.tableView?.indexPath(for: cell) {
            
            if let contactDetailsVC = segue.destination as? ContactDetailsVC {
                contactDetailsVC.crtContact = arrContacts[indexPath.row]
            }
        }        
    }
    
    
    //MARK: - API calls
    
    private func requesGetContacts() {
        
        AFWrapper.requestGetContacts(params: nil, success: {
            (resJson) -> Void in
            
            let dataBase = ContactBase.init(dictionary: resJson.dictionaryObject! as NSDictionary)
            
            if let arrContactData = dataBase?.data {
                self.arrContacts = arrContactData
                os_log("data-----------------%@", log: .default, type: .debug,  self.arrContacts)
                
                self.tableView.reloadData()
            }
            
            
            
        }) {
            (error) -> Void in
            
            self.alert(message: error.localizedDescription)
        }
    }

}
