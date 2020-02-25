//
//  JLPlayItem.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/23.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

/// 播放器中audio的item
class JLPlayItem: NSObject {
    let trackItem: Track_Full
    let songUrl: URL

    var isSelected: Bool = false
    var isFirst: Bool = false
    var isLast: Bool = false
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? JLPlayItem {
            return songUrl == object.songUrl
        }

        return false
        
    }
    
    init(item:Track_Full, songUrl:URL) {
        self.trackItem = item
        self.songUrl = songUrl
    
    }
}
