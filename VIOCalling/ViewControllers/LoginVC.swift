//
//  LoginVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 12/11/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMeetingID: UITextField!
    @IBOutlet weak var constLogoTop: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.constLogoTop.constant = self.view.frame.height * 0.25
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private
    
    /**
     A method to initialize basic view of this screen.
     */
    func initView() {
        self.textFieldUserName.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.textFieldMeetingID.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.textFieldMeetingID.isSecureTextEntry = true
        VCConnectorPkg.vcInitialize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        VidyoManager.videoVC = storyboard.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC
    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnLogin(_ sender: Any) {
        let arrUserName = self.textFieldUserName.text?.components(separatedBy: " ")
        
        if ((arrUserName?.count)! > 1) {
            alert(message: "No space allowed in username.")
        } else {
            Utile.saveUserName(self.textFieldUserName.text?.trimmingCharacters(in: .whitespaces))
            self.requesGetAccessTokenData()
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if (!(textFieldUserName.text?.isEmpty)! && !(textFieldMeetingID.text?.isEmpty)!) {
            btnLogin.isEnabled = true
            btnLogin.alpha = 1.0
        } else {
            btnLogin.isEnabled = false
            btnLogin.alpha = 0.5
        }
    }
    
    //MARK: - API calls
    
    /**
     A method to get access token from server.
     */
    private func requesGetAccessTokenData() {
        
        AFWrapper.requestGetAccessToken(params: nil, success: {
            (resJson) -> Void in
            
            let accessTokenBase = AccessTokenBase.init(dictionary: resJson.dictionaryObject! as NSDictionary)
            Utile.saveAccessToken(accessTokenBase?.accessToken)
            VidyoManager.sharedInstance.initVidyoConnector()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.subscribePublicChannel(with: Utile.getUserName()!)
            appDelegate.loginToHomeVC()            
        }) {
            (error) -> Void in
            
            self.alert(message: error.localizedDescription)
        }
    }
}
