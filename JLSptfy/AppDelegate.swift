//
//  AppDelegate.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import Alamofire
import SZAVPlayer

let JLRefreshTokenKey = "refreshToken"
let JLTokenExpriedDateKey = "tokenExpirationDate"
let JLAccessTokenKey = "accessToken"
let JLSessionKey = "session"
let JLWYUserCookiesKey = "wy_UserCookies"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    var window: UIWindow?
    
    fileprivate let SpotifyClientID = "16828f5eeb34451d878de2e60b6b5474"
    fileprivate let SpotifyRedirectURI = URL(string: "jlsptfy-login://callback")!

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = nil

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "https://jlsptfy-login.herokuapp.com/swap")
        configuration.tokenRefreshURL = URL(string: "https://jlsptfy-login.herokuapp.com/refresh")
        
        
        SZAVPlayerAssetLoader
        
        return configuration
    }()
    


    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    


    var accessToken = UserDefaults.standard.string(forKey: JLAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: JLAccessTokenKey)
            defaults.synchronize()
        }
    }
    

    
    var refreshToken = UserDefaults.standard.string(forKey: JLRefreshTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(refreshToken, forKey: JLRefreshTokenKey)
            defaults.synchronize()
        }
    }
    
    var sptSession = UserDefaults.standard.value(forKey: JLSessionKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(sptSession, forKey: JLSessionKey)
            defaults.synchronize()
        }
    }
    

    
    var tokenExpirationDate = UserDefaults.standard.value(forKey: JLTokenExpriedDateKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(tokenExpirationDate, forKey: JLTokenExpriedDateKey)
            
            defaults.synchronize()
        }

    }
    
    @objc dynamic var WY_UserCookies = UserDefaults.standard.value(forKey: JLWYUserCookiesKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(WY_UserCookies, forKey: JLWYUserCookiesKey)
            defaults.synchronize()
        }
    }
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: AppDelegate.sharedInstance.configuration, delegate: self)
        
        return manager
    }()
    
    
    var rootController = JLLoginViewController.init(nibName: "JLLoginViewController", bundle: nil)
    
    
    var mediaPlayer: SZAVPlayer = SZAVPlayer()
    
    
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.rootViewController = rootController
        //        window?.rootViewController = JLPlayerViewController()
        window?.makeKeyAndVisible()
        
        
        
        /*第三方键盘辅助*/
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.toolbarManageBehaviour = .byTag
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5


        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if window?.rootViewController?.isKind(of: JLLoginViewController.self) == true {
            sessionManager.application(app, open: url, options: options)
        }

        return true
    }
    
    

    

    
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    



}

extension AppDelegate: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        DispatchQueue.main.async {

            self.accessToken = session.accessToken
            self.refreshToken = session.refreshToken
            self.tokenExpirationDate = session.expirationDate.addingTimeInterval(3600*8)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: session, requiringSecureCoding: false)
                self.sptSession = data
            } catch {
                print(error)
            }
            
            let viewController = TabBarController()
//            viewController.modalPresentationStyle = .fullScreen
//            self.window?.rootViewController?.present(viewController, animated: true, completion: {
////                self.window?.rootViewController = viewController
////                self.window?.makeKeyAndVisible()
//            })
            
            let transtition = CATransition()
            transtition.duration = 0.5
            transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            self.window?.layer.add(transtition, forKey: "animation")
            self.window?.rootViewController = viewController
            
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.window?.rootViewController?.presentAlertController(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            if self.window?.rootViewController?.isKind(of: JLLoginViewController.self) ?? false {
                (self.window?.rootViewController as! JLLoginViewController).changeButtonStatus(true)
            }
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        DispatchQueue.main.async {
            if self.window?.rootViewController?.isKind(of: JLLoginViewController.self) ?? false {
                DispatchQueue.main.async {

                    self.accessToken = session.accessToken
                    self.refreshToken = session.refreshToken
                    self.tokenExpirationDate = session.expirationDate.addingTimeInterval(3600*8)
                    
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: session, requiringSecureCoding: false)
                        self.sptSession = data
                    } catch {
                        print(error)
                    }
                    
                    let viewController = TabBarController()
                    
//                    viewController.modalPresentationStyle = .fullScreen
//                    self.window?.rootViewController?.present(viewController, animated: true, completion:
//                        {
//
//                            UIApplication.shared.windows[0].rootViewController = viewController
//                            UIApplication.shared.windows[0].makeKeyAndVisible()
//                    })
//
                    
                    let transtition = CATransition()
                    transtition.duration = 0.5
                    transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                    self.window?.layer.add(transtition, forKey: "animation")
                    self.window?.rootViewController = viewController
                    
                }
            }
        }
    }
    
    
}
