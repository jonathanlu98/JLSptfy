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
import SDWebImage
import YYKit


let JLRefreshTokenKey = "refreshToken"
let JLTokenExpriedDateKey = "tokenExpirationDate"
let JLAccessTokenKey = "accessToken"
let JLSessionKey = "session"
let JLWYUserCookiesKey = "wy_UserCookies"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    // MARK: spotify 配置，请仔细阅读spotify developer官网中iOS开发的介绍，该Framework在这只做登录获取Token，采用OAuth 2.0协议
    
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

        return configuration
    }()
    
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
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: AppDelegate.sharedInstance.configuration, delegate: self)
        
        return manager
    }()
    
    // MARK: 网易云用户的Cookies
    
    @objc dynamic var WY_UserCookies = UserDefaults.standard.value(forKey: JLWYUserCookiesKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(WY_UserCookies, forKey: JLWYUserCookiesKey)
            defaults.synchronize()
        }
    }
    
//    let JLFetchDispatchQueuePool: YYDispatchQueuePool = .init(name: "JLFetch", queueCount: 32, qos: .utility)
    
    // MARK: UI
    

    var window: UIWindow?
    
    var rootController = JLLoginViewController.init(nibName: "JLLoginViewController", bundle: nil)
    
    /// 第三方播放器
    var player = JLPlayer.shared
    
    
    //MARK: FUNC
    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        
        
        /*第三方键盘辅助*/
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.toolbarManageBehaviour = .byTag
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5
        
        //AVFoundation中的必须，用于后台激活
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setActive(true)
//            try session.setCategory(AVAudioSession.Category.playback)
//        } catch {
//            print(error)
//        }
        
        SZAVPlayer.activeAudioSession()
        
        //让Alamofire中不带缓存请求
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        //SZAVPlayer不带缓存
        SZAVPlayerCache.shared.setup(maxCacheSize: 0)
        
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if window?.rootViewController?.isKind(of: JLLoginViewController.self) == true {
            sessionManager.application(app, open: url, options: options)
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("zoule")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("laile")
        guard let viewController = UIViewController.currentViewController() else {
            return
        }
        if viewController.isKind(of: JLPlayerViewController.self) {
            print("keyi")
            JLPlayer.shared.viewController.checkView()
        }
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
            
            let viewController = JLTabBarController()
            //渐进效果加载
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
                (self.window?.rootViewController as! JLLoginViewController).loginButton.changStatus(isDisabled: false, disabledColor: #colorLiteral(red: 0.3254599571, green: 0.3255102634, blue: 0.3254440129, alpha: 1), enabledColor: #colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1))
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
                    
                    let viewController = JLTabBarController()
                    
                    //渐进效果加载
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
