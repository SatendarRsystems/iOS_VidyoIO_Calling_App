//
//  ContactDetailsVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 29/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private
    
    /**
     A method to initialize basic view of this screen.
     */
    private func initView() {
        imgViewContact.layer.masksToBounds = true
        lblContactName.text = crtContact.name
        
        if let url = URL(string: crtContact.profilePic!) {
            imgViewContact.af_setImage(withURL: url)
        }
        
        switchCamera.isOn = Utile.getSwitchOffCamera()!
        switchMicrophone.isOn = Utile.getSwitchOffMic()!
        enableDisableCallBtn()
    }
    
    private func enableDisableCallBtn() {
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
        Utile.saveCallerID(crtContact.name)
        Utile.saveSwitchOffCamera(switchCamera.isOn)
        Utile.saveSwitchOffMic(switchMicrophone.isOn)
        
        var dicParam: [String : String] = [:]
        dicParam["displayName"] = Utile.getUserName()
        dicParam["eventName"] = crtContact.name?.lowercased()
        let meetingID = "123"
        Utile.saveMeetingID(meetingID)
        dicParam["resourceId"] = meetingID
//        os_log("dicParam:- %@", log: .default, type: .debug,  dicParam)
        
        requesPostInitiateCall(params: dicParam as [String : AnyObject])
    }
    
    @IBAction func clickedBtnPhone(_ sender: UIButton) {
    }
    @IBAction func clickedBtnMail(_ sender: UIButton) {
    }
    
    //MARK: - API calls
    
    private func requesPostInitiateCall(params: [String : AnyObject]) {
        AFWrapper.requestPostInitiateCall(params: params, success: {
            (resJson) -> Void in
            
            let resModel = InitiateCallBase.init(dictionary: resJson.dictionaryObject! as NSDictionary)
            if resModel?.success == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OutgoingCallVC") as! OutgoingCallVC
                vc.strContactName = self.crtContact.name
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
            
        }, failure: {
            (error) -> Void in
        })
    }
}
