//
//  JLPlayer.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/3/30.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import SZAVPlayer

class JLPlayer: NSObject {
    
    let viewController:JLPlayerViewController = .shared
    
    private(set) var menuView: UIView!
    
    let mediaPlayer = SZAVPlayer()
    
    override private init() {
        
        super.init()
    }
    
    /// Returns the default singleton instance.
    @objc public static let shared = JLPlayer.init()
    
    

}
