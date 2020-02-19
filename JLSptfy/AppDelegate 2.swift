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
        
        return configuration
    }()
    


    
    class var sharedInstance: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    // keys
    static private let kAccessTokenKey = "accessToken"

    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: AppDelegate.kAccessTokenKey)
            defaults.synchronize()
        }
    }
    
    var rootController = JLLoginViewController.init(nibName: "JLLoginViewController", bundle: nil)
    
    
    var mediaPlayer: STKAudioPlayer = STKAudioPlayer()


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
        
        
        
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if window?.rootViewController?.isKind(of: JLLoginViewController.self) == true {
            (window?.rootViewController as! JLLoginViewController).sessionManager.application(app, open: url, options: options)
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //appRemote.disconnect()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //appRemote.connect()
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

