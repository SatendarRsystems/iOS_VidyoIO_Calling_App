//
//  IncomingCallVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 02/11/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class IncomingCallVC: UIViewController {
    @IBOutlet weak var lblContactName: UILabel!
    var strContactName: String!
    
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
    func initView() {
        lblContactName.text = strContactName
    }
    
    //MARK: - Actions

    @IBAction func clickedBtnDecline(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        var dicParam: [String : Any] = [:]
        dicParam["eventName"] = strContactName.lowercased()
        dicParam["isAccept"] = false
        
        requesPostRejectCall(params: dicParam as [String : AnyObject])
    }
    @IBAction func clickedBtnAnswer(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        
        Utile.showProgressIndicator()
        VidyoManager.sharedInstance.initVidyoConnector()
        VidyoManager.sharedInstance.refreshUI()
        VidyoManager.sharedInstance.connectMeeting()
        VidyoManager.sharedInstance.switchOffMic(false)
        VidyoManager.sharedInstance.switchOffSpeaker(false)
        VidyoManager.sharedInstance.switchOffCamera(true)
        
        var dicParam: [String : Any] = [:]
        dicParam["eventName"] = strContactName.lowercased()
        dicParam["isAccept"] = true
        
        requesPostAcceptCall(params: dicParam as [String : AnyObject])
    }
    
    //MARK: - API calls
    
    private func requesPostAcceptCall(params: [String : AnyObject]) {
        AFWrapper.requestPostAcceptRejectCall(params: params, showActivity: false, success: {
            (resJson) -> Void in
            
        }, failure: {
            (error) -> Void in            
        })
    }
    
    private func requesPostRejectCall(params: [String : AnyObject]) {
        AFWrapper.requestPostAcceptRejectCall(params: params, showActivity: false, success: {
            (resJson) -> Void in
            
        }, failure: {
            (error) -> Void in
        })
    }
}
