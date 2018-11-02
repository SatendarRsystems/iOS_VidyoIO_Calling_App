//
//  OutgoingCallVC.swift
//  VIOCalling
//
//  Created by Arun Kumar on 30/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class OutgoingCallVC: UIViewController {
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

    @IBAction func clickBtnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
