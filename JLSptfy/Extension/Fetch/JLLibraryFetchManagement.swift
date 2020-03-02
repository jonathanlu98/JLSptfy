//
//  JLLibraryFetchManagement.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/25.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import Alamofire

class JLLibraryFetchManagement: NSObject {
    /**
     每次搜索限制的个数。
     */
    public var limit:Int = 20
    /**
     在该搜索结果下的索引值。配合limit可实现翻页效果
     */
    private(set) var offset:Int = 0
    /**
     搜索类型。
     */
    private(set) var type:JLLibraryContentType?
    /**
     拉取的次数，用于搜索单类的时候下拉定位offset
     */
    private(set) var pulls:Int = 0
    /**
     用于Library的artist获取，他与其他的get请求的参数不相同
     */
    private(set) var lastFollowedArtistID:String?
    
    
    typealias JLLibraryCompletionBlock = (JLLibraryQuickJSON?, Int, Error?) -> Void
    
    override init() {
        super.init()
    }
    
    
    init(limit:Int, type:JLLibraryContentType) {
        super.init()
        self.limit = limit
        self.type = type
    }
    
    /**
     用于spotify获取Library的方法
     
     - Parameter type: 搜索类型
     - Parameter isReload: 是否重载，用于上拉刷新
     - Parameter completed: 完成返回Block，返回json，offset，error
    */
    func fetchMyLibrary(type: JLLibraryContentType, isReload: Bool, completed completedBlock: JLLibraryCompletionBlock?) {
        self.type = type
        
        let oldOffset = self.offset
        let oldLastFollowedArtistID = self.lastFollowedArtistID

        if isReload == true {
            self.lastFollowedArtistID = nil
            self.offset = 0
        } else {
            
            self.offset = pulls*limit
        }
        
        var urlString = ""
        var paras:[String:String] = [:]
        let headers: HTTPHeaders = ["Authorization":"Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? "")]
        
        if type == .Artists {
            if self.lastFollowedArtistID != nil {
                urlString = "https://api.spotify.com/v1/me/following"
                paras = ["type":"artist","limit":String(self.limit),"after":self.lastFollowedArtistID!]
            } else {
                urlString = "https://api.spotify.com/v1/me/following"
                paras = ["type":"artist","limit":String(self.limit)]
            }

        } else {
            urlString = "https://api.spotify.com/v1/me/"+type.description()
            paras = ["limit":String(self.limit),"offset":String(self.offset)]
        }
        
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            guard let data = response.data else {
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    self.lastFollowedArtistID = oldLastFollowedArtistID
                    completedBlock?(nil, self.offset, response.error)
                }
                return
            }

            do {
                var json: JLLibraryQuickJSON!
                switch type {
                    
                case .Playlists:
                    json = .Playlists(item: try .init(data: data))
                case .Artists:
                    json = .Artists(item: try .init(data: data))
                case .Albums:
                    json = .Albums(item: try .init(data: data))
                case .Tracks:
                    json = .Songs(item: try .init(data: data))
                    
                }
                
                if (completedBlock != nil) {
                    if isReload == true {
                        self.pulls = 1
                        self.lastFollowedArtistID = json.getLastFollowingID()
                        completedBlock!(json, self.offset, nil)
                    } else {
                        self.pulls += 1
                        self.lastFollowedArtistID = json.getLastFollowingID()
                        completedBlock!(json, self.offset, nil)

                    }
                }

            } catch {
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    self.lastFollowedArtistID = oldLastFollowedArtistID
                    completedBlock!(nil, self.offset, error)
                }
            }
        }
    }
    
}
