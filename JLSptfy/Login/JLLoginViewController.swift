//
//  JLLoginViewController.swift
//  JLSpfRadioView
//
//  Created by Jonathan Lu on 2020/2/4.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

class JLLoginViewController: UIViewController, SPTSessionManagerDelegate {
    
    

    
    
//    fileprivate let SpotifyClientID = "16828f5eeb34451d878de2e60b6b5474"
//    fileprivate let SpotifyRedirectURI = URL(string: "jlsptfy-login://callback")!
//
//    lazy var configuration: SPTConfiguration = {
//        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
//        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
//        // otherwise another app switch will be required
//        configuration.playURI = ""
//
//        // Set these url's to your backend which contains the secret to exchange for an access token
//        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//        configuration.tokenSwapURL = URL(string: "https://jlsptfy-login.herokuapp.com/swap")
//        configuration.tokenRefreshURL = URL(string: "https://jlsptfy-login.herokuapp.com/refresh")
//
//        return configuration
//    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: AppDelegate.sharedInstance.configuration, delegate: self)
        
        return manager
    }()



    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapConnect(_ button: UIButton) {
        if button.isEnabled {
            button.isEnabled = false
            button.backgroundColor = #colorLiteral(red: 0.3254599571, green: 0.3255102634, blue: 0.3254440129, alpha: 1)
        }

        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .streaming, .userLibraryRead, .userReadPrivate, .userFollowRead]

        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .default)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: scope, options: .default, presenting: self)
        }
        
    }
    


    
    // MARK: - Spotify delegate
    

    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        //appRemote.connectionParameters.accessToken = session.accessToken
        
        //


        DispatchQueue.main.async {
//            let defaults = UserDefaults.standard
//            defaults.set(session.accessToken, forKey: "accessToken")
//            defaults.synchronize()
            AppDelegate.sharedInstance.accessToken = session.accessToken
            AppDelegate.sharedInstance.appRemote.connectionParameters.accessToken = session.accessToken
            let viewController = TabBarController()
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        DispatchQueue.main.async {
            self.presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
            if !self.loginButton.isEnabled {
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)
            }
        }
    }
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
