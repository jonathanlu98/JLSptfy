//
//  JLMeTableViewCell.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/22.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxSwift
import YYKit

enum JLMeTableViewCellType {
    case spotify
    case wangyiyun
}



class JLMeTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var connectButton: UIButton!
    
    var type: JLMeTableViewCellType!
    
    var isWYLogined: Bool!
    
    var WYloginViewController:JLWYLoginViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        connectButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        connectButton.layer.shadowOffset = .init(width: 0, height: 3)
        connectButton.layer.shadowOpacity = 6
        
        self.contentView.layer.cornerRadius = 7
        self.contentView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        self.contentView.layer.shadowOffset = .init(width: 0, height: 3)
        self.contentView.layer.shadowOpacity = 6

        
        self.contentView.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self.mas_leading)?.offset()(16)
            make?.trailing.equalTo()(self.mas_trailing)?.offset()(-16)
            make?.top.equalTo()(self.mas_top)?.offset()(30)
            make?.bottom.equalTo()(self.mas_bottom)
        }
        
        // Initialization code
        
    }
    



    
    
    func setupCell(_ type: JLMeTableViewCellType) {
        self.type = type
        switch type {
        case .spotify:
            self.iconImageView.image = #imageLiteral(resourceName: "spotify")
            self.connectButton.setTitle("REFRESH", for: .normal)
            self.connectButton.addTarget(self, action: #selector(SPTRefreshAction), for: .touchUpInside)
        case .wangyiyun:
            self.iconImageView.image = #imageLiteral(resourceName: "wangyiyun")
            
            if AppDelegate.sharedInstance.WY_UserCookies  == nil {
                self.connectButton.setTitle("LOGIN", for: .normal)
                
                self.connectButton.addTarget(self, action: #selector(WYLoginAction), for: .touchUpInside)
                
            } else {
                self.connectButton.setTitle("LOGOUT", for: .normal)
                
                self.connectButton.addTarget(self, action: #selector(WYLogoutAction), for: .touchUpInside)
                

            }

        }
        
        
    }
    
    @objc func WYLoginAction() {
        self.WYloginViewController = JLWYLoginViewController()
        AppDelegate.sharedInstance.window?.rootViewController?.present(self.WYloginViewController!, animated: true, completion: nil)
        self.WYloginViewController!.updateBlock = { value in
            if value {
                self.setupCell(.wangyiyun)
            }
        }
    }
    
    @objc func WYLogoutAction() {
        AppDelegate.sharedInstance.WY_UserCookies = nil
        JLWYLoginManagement.shared.userCookies = []
       URLCache.shared.removeAllCachedResponses()
        self.connectButton.setTitle("LOGIN", for: .normal)
    }
    
    @objc func SPTRefreshAction() {
        self.connectButton.changStatus(isDisabled: true, disabledColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), enabledColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        AppDelegate.sharedInstance.sessionManager.delegate = self
        AppDelegate.sharedInstance.sessionManager.renewSession()
    }
    
    

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension JLMeTableViewCell: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        
        DispatchQueue.main.async {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: session, requiringSecureCoding: false)
                AppDelegate.sharedInstance.sptSession = data
            } catch {
                print(error)
            }
            AppDelegate.sharedInstance.accessToken = session.accessToken
            AppDelegate.sharedInstance.refreshToken = session.refreshToken
            AppDelegate.sharedInstance.tokenExpirationDate = session.expirationDate.addingTimeInterval(3600*8)
            

            self.connectButton.changStatus(isDisabled: false, disabledColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), enabledColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
    }
    
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.window?.rootViewController?.presentAlertController(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            
            self.connectButton.changStatus(isDisabled: false, disabledColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), enabledColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
    }
    
    
}
