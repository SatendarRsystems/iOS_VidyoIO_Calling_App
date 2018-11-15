//
//  VideoVC.swift
//  VIO
//
//  Summary: VideoVC Component
//  Description: Used to display video chat screen.
//
//  Created by Arun Kumar on 08/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

    @IBOutlet var viewVideo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        VidyoManager.sharedInstance.switchOffCamera(true)
        VidyoManager.sharedInstance.switchOffMic(true)
        VidyoManager.sharedInstance.switchOffSpeaker(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        VidyoManager.sharedInstance.refreshUI()
        
    }
        
    @IBAction func clickedBtnChat(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            VidyoManager.sharedInstance.disconnectMeeting()
        })
        
        var dicParam: [String : Any] = [:]
        dicParam["eventName"] = Utile.getCallerID()?.lowercased()
        fetchPostCallEndedAPI(params: dicParam as [String : AnyObject])
    }
    @IBAction func clickedBtnCameraSwitch(_ sender: UIButton) {        
        VidyoManager.sharedInstance.switchCamera()
    }
    @IBAction func clickedBtnCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "CameraOff"), for: .normal)
            VidyoManager.sharedInstance.switchOffCamera(true)
            
        } else {
            sender.setImage(#imageLiteral(resourceName: "CameraOn"), for: .normal)
            VidyoManager.sharedInstance.switchOffCamera(false)
        }
    }
    @IBAction func clickedBtnMic(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "micOff"), for: .normal)
            VidyoManager.sharedInstance.switchOffMic(true)
            
        } else {
            sender.setImage(#imageLiteral(resourceName: "micOn"), for: .normal)
            VidyoManager.sharedInstance.switchOffMic(false)
        }
    }
    
    //MARK: - API calls
    
    private func fetchPostCallEndedAPI(params: [String : AnyObject]) {
        AFWrapper.requestPostCallEnded(params: params, showActivity: false, success: {
            (resJson) -> Void in
            
        }, failure: {
            (error) -> Void in
        })
    }
}
