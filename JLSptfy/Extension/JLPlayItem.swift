//
//  JLPlayItem.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/23.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

class JLPlayItem: NSObject {
    let coverUrl: String
    let title: String
    let artistName: String
    let albumName: String
    let url: URL

    var isSelected: Bool = false
    var isFirst: Bool = false
    var isLast: Bool = false
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? JLPlayItem {
            return url == object.url
        }

        return false
        
    }
    
    init(coverUrl:String, title:String, artistName:String, albumName:String, url:URL) {
        self.coverUrl = coverUrl
        self.title = title
        self.artistName = artistName
        self.albumName = albumName
        self.url = url
    
    }
}
