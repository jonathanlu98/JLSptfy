//
//  JLSearchListSection.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/25.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import Foundation
import RxDataSources

//单元格类型
enum JLSearchListSectionItem {
    case ArtistSectionItem(item: Artist_Full)
    case AlbumSectionItem(item: Album_Simplified)
    case SongSectionItem(item: Track_Full)
    case PlaylistSectionItem(item: Playlist_Simplified)
    case MoreSectionItem(type: JLSearchType,text: String)
}
 
//自定义Section
struct JLSearchListSection {
    var header: String
    var items: [JLSearchListSectionItem]
}
 
extension JLSearchListSection : SectionModelType {
    typealias Item = JLSearchListSectionItem
     
    init(original: JLSearchListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
