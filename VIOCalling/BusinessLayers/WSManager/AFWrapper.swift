//
//  AFWrapper.swift
//  VIO
//
//  Summary: AFWrapper Component
//  Description: A business layer class for API calling
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import os.log

class AFWrapper {
    static let baseUrl = "https://us-central1-vidyo-1.cloudfunctions.net"
    
    /**
     A method to get authontication headers in key-value format
     */
    class func getoAuthHeaders() -> HTTPHeaders {
        
        let oauthHeaders: HTTPHeaders = [
//            "authorization": UserDefaults.standard.string(forKey: "oauthToken")!,
            "accept": "application/json",
        ]
        return oauthHeaders
    }
    
    //MARK: - Base request  URL Method
    
    /**
     A method to  request the API through GET or POST method
     */
    class func requestURL(_ strURL: String ,params : [String : AnyObject]?, method: HTTPMethod, showActivity: Bool, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let oauthHeaders = self.getoAuthHeaders()
        
        if showActivity {
            Utile.showProgressIndicator()
        }
        
        os_log("strURL:- %@", log: .default, type: .debug,  strURL)
        
        Alamofire.request(strURL, method: method, parameters: params, encoding: JSONEncoding.default, headers: oauthHeaders).validate().responseJSON { (responseObject) -> Void in
            
            Utile.hideProgressIndicator()
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
//                os_log("resJson:- %{public}@", log: .default, type: .debug, String(describing: resJson))
                success(resJson)
            }
            else if responseObject.result.isFailure {
                os_log("error:- %@", log: .default, type: .debug,  (responseObject.result.error?.localizedDescription)!)
                failure(responseObject.result.error!)
            }
        }
    }
    
    //MARK: - JoinMeetingVC screen API methods
    
    /**
     A method to  request the access token through GET method
     */
    class func requestGetAccessToken(params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/authToken?username=%@", Utile.getUserName()!)

        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr, params: params, method: .get, showActivity: true, success: {
            (resJson) -> Void in
            success(resJson)
            
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    /**
     A method to  get contact list data
     */
    class func requestGetContacts(params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/getContacts")
        
        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr, params: params, method: .get, showActivity: true, success: {
            (resJson) -> Void in
            success(resJson)
            
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    /**
     A method to post data for call initiating
     */
    class func requestPostInitiateCall(params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/initiateCall")
        
        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr, params: params, method: .post, showActivity: true, success: {
            (resJson) -> Void in
            success(resJson)

        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    /**
     A method to post data for accept/reject call
     */
    class func requestPostAcceptRejectCall(params : [String : AnyObject]?, showActivity: Bool, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/acceptRejectCall")
        
        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr, params: params, method: .post, showActivity: showActivity,  success: {
            (resJson) -> Void in
            success(resJson)
            
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    /**
     A method to post data for call ending
     */
    class func requestPostCallEnded(params : [String : AnyObject]?, showActivity: Bool, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/callEnded")
        
        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr, params: params, method: .post, showActivity: showActivity,  success: {
            (resJson) -> Void in
            success(resJson)
            
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
}
