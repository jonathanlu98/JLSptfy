//
//  JLLibraryQuickJSON.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/14.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

enum ContentType {
    case Playlists
    case Artists
    case Albums
    case Tracks
    
    func description() -> String {
        switch self {

        case .Playlists:
            return "playlists"
        case .Artists:
            return "artists"
        case .Albums:
            return "albums"
        case .Tracks:
            return "tracks"

        }
    }
}

enum JLLibraryQuickJSON {
    case Playlists(item: Playlists)
    case Albums(item: Albums)
    case Artists(items: Artists)
    case Songs(items: Tracks)
    case none
}





