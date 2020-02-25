//
//  JLWYLoginManagement.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/22.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import Alamofire

class JLWYLoginManagement: NSObject {
    /**
    Returns the default singleton instance.
    */
    @objc public static let shared = JLWYLoginManagement()
    
    /// 网易用户的cookie
    var userCookies: Array<String> = []
    
    typealias JLLoginCompletionBlock = (Bool,Error?) -> Void
    
    
    /// 登录网易云音乐
    /// - Parameters:
    ///   - phone: 手机号
    ///   - password: 密码
    ///   - completedBlock: 完成Block，返回succeed，error
    func login(phone: String, password: String, completedBlock:@escaping JLLoginCompletionBlock) {
        let urlString = "http://developer.iscuec.club:3000/login/cellphone"
        let paras = ["phone":phone,"password":password]
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let headerFields = response.response?.allHeaderFields as! [String:String]
            var cookies: Array<String> = []
            for item in headerFields {
                if item.key == "Set-Cookie" {
                    cookies.append(item.value)
                }
            }
            if cookies.count != 0 {
                self.userCookies = cookies
                AppDelegate.sharedInstance.WY_UserCookies = cookies
                completedBlock(true,nil)
            } else {
                completedBlock(false,response.error)
            }
        }
    }
}
