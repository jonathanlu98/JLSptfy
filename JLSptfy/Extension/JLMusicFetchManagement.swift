//
//  JLMusicFetchManagement.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/20.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class JLMusicFetchManagement: NSObject {
    
    typealias JLSearchIdCompletionBlock = (Int?, Error?) -> Void
    
    typealias JLGetMusicUrlCompletionBlock = (URL?, Error?) -> Void
    
    
    
    
    /**
    Returns the default singleton instance.
    */
    @objc public static let shared = JLMusicFetchManagement()
    
    
    
    func getMusicUrl(item: Track_Full, completedBlock: JLGetMusicUrlCompletionBlock?) {
        self.searchId(item: item) { (id, error) in
            if (id != nil) {
                
                
                let urlString = "http://developer.iscuec.club:3000/song/url"
                let paras = ["id":String(id!)]
                var cookiesString = ""
                var cookies:Dictionary<String,String>?
                if AppDelegate.sharedInstance.WY_UserCookies != nil {
                    for cookiesItem in AppDelegate.sharedInstance.WY_UserCookies as! Array<String> {
                        cookiesString = cookiesString+cookiesItem
                    }
                    cookies = ["Cookies":cookiesString]
                }
                
                Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: cookies).responseData { (response) in
                    guard let data = response.data else {
                        
                        print(String(describing: response.error))
                        if (completedBlock != nil) {
                            completedBlock!(nil, response.error)
                        }
                        return
                    }
                        do {
                            let json = try WYMusicDataJSON.init(data: data)
                            print(json)
                            if (completedBlock != nil && json.data?.first?.url != nil) {
                                completedBlock!(URL(string: (json.data?.first?.url)!), nil)
                            } else if (completedBlock != nil && json.data?.first?.url == nil) {
                                completedBlock!(nil, NSError.init(domain: NSURLErrorDomain, code: 200, userInfo: [NSLocalizedDescriptionKey:"该歌曲可能需要付费或者没有版权，或者其他未知原因"]))
                            }
                            
                        } catch {
                            print(error)
                            if (completedBlock != nil) {
                                completedBlock!(nil, error)
                            }
                        }
                }

            } else {
                if (completedBlock != nil) {
                    completedBlock!(nil, NSError.init(domain: NSURLErrorDomain, code: 200, userInfo: [NSLocalizedDescriptionKey:"该歌曲可能在网易云中关键词太长或者不匹配，或者其他未知原因"]))
                }
            }
        }
    }
    
    func searchId(item: Track_Full, completedBlock: JLSearchIdCompletionBlock?) {
//        let semaphore = DispatchSemaphore (value: 0)
        var searchString = ""
        if item.name != nil {
            searchString = (item.name ?? "")
        }
        let urlString = "http://developer.iscuec.club:3000/search"
        let paras = ["keywords":searchString, "limit":"50", "type":"1"]
        
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            
            guard let data = response.value else {
                print(String(describing: response.error))
                if (completedBlock != nil) {
                    completedBlock!(nil, response.error)
                }
                return
            }
            
            do {
                let json = try WYMusicJSON.init(data: data)
                print(json)
                if (completedBlock != nil) {
                    
                    completedBlock!(self.screenData(json: json, original: item), nil)
                }

            } catch {
                print(error)
                if (completedBlock != nil) {
                    completedBlock!(nil, error)
                }
            }

        }
        
    }
    
//    func fetchMp3(item: Track_Full, completedBlock: JLSearchIdCompletionBlock?)
    
    
    func screenData(json: WYMusicJSON, original: Track_Full) -> Int? {
        for item in json.result?.songs ?? [] {
            if item.album?.name == original.album?.name && item.name == original.name && item.artists?.first?.name == original.artists?.first?.name {
                return item.id
            }
        }
        return nil
    }
    
    func isPlayable(id: String) {
        
    }
    
    
    
}
