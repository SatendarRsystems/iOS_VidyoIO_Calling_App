//
//  ContactDetailsVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 29/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class ContactDetailsVC: UIViewController {
    @IBOutlet weak var imgViewContact: UIImageView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var switchCamera: UISwitch!
    @IBOutlet weak var switchMicrophone: UISwitch!
    
    var crtContact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     A method to initialize basic view of this screen.
     */
    func initView() {
        imgViewContact.layer.masksToBounds = true
        lblContactName.text = crtContact.name
        
        if let url = URL(string: crtContact.profilePic!) {
            imgViewContact.af_setImage(withURL: url)
        }
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func enableDisableCallBtn() {
        if switchCamera.isOn == false, switchMicrophone.isOn == false {
            btnCall.isEnabled = false
            btnCall.alpha = 0.5
        } else {
            btnCall.isEnabled = true
            btnCall.alpha = 1.0
        }
    }

    // MARK: - Actions

    @IBAction func clickedSwitchCamera(_ sender: UISwitch) {
        enableDisableCallBtn()
    }
    @IBAction func clickedSwitchMicrophone(_ sender: UISwitch) {
        enableDisableCallBtn()
    }
    @IBAction func clickedBtnCall(_ sender: UIButton) {
    }
    @IBAction func clickedBtnPhone(_ sender: UIButton) {
    }
    @IBAction func clickedBtnMail(_ sender: UIButton) {
    }
}