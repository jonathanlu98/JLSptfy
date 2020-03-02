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
    let wySongUrl: URL
    let wySongId: Int

    var isSelected: Bool = false
    var isFirst: Bool = false
    var isLast: Bool = false
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? JLPlayItem {
            return wySongId == object.wySongId
        }

        return false
        
    }
    
    init(item:Track_Full, wySongUrl:URL, wySongId:Int) {
        self.trackItem = item
        self.wySongUrl = wySongUrl
        self.wySongId = wySongId
    }
}
