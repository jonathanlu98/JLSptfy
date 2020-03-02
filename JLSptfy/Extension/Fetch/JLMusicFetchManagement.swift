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
    
    typealias JLGetMusicUrlCompletionBlock = (WYSongData?, Error?) -> Void
    
    typealias JLGetMusicUrlsCompletionBlock = ([Int:WYSongData]?) -> Void
    
    typealias JLSearchIdsCompletionBlock = ([Int:Int]?) -> Void
    /**
    Returns the default singleton instance.
    */
    @objc public static let shared = JLMusicFetchManagement()
    
    /// 获取网易音乐url
    /// - Parameters:
    ///   - item: spotify的单曲item
    ///   - completedBlock: 完成的Block，返回url，error
    func getMusicUrl(item: Track_Full, completedBlock: JLGetMusicUrlCompletionBlock?) {
        self.searchId(item: item) { (id, error) in
            if (id != nil) {
                let urlString = "http://developer.iscuec.club:3000/song/url"
                let paras = ["id":String(id!),"br":"320000"]
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
                        
                        if (completedBlock != nil) {
                            completedBlock!(nil, response.error)
                        }
                        return
                    }
                        do {
                            let json = try WYMusicDataJSON.init(data: data)
                            if (completedBlock != nil && json.data?.first?.url != nil) {
                                completedBlock!(json.data?.first, nil)
                            } else if (completedBlock != nil && json.data?.first?.url == nil) {
                                completedBlock!(nil, NSError.init(domain: NSURLErrorDomain, code: 200, userInfo: [NSLocalizedDescriptionKey:"该歌曲可能需要付费或者没有版权，或者其他未知原因"]))
                            }
                            
                        } catch {
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
    
    /// 搜索关键字在网易云中的歌曲id
    /// - Parameters:
    ///   - item: spotify的单曲item
    ///   - completedBlock: 完成Block，返回Id，error'
    func searchId(item: Track_Full, completedBlock: JLSearchIdCompletionBlock?) {

        var searchString = ""
        if item.name != nil {
            searchString = (item.name ?? "")
        }
        let urlString = "http://developer.iscuec.club:3000/search"
        let paras = ["keywords":searchString, "limit":"50", "type":"1"]
        
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            
            guard let data = response.value else {
                if (completedBlock != nil) {
                    completedBlock!(nil, response.error)
                }
                return
            }
            
            do {
                let json = try WYMusicJSON.init(data: data)
                if (completedBlock != nil) {
                    
                    completedBlock!(self.screenData(json: json, original: item), nil)
                }

            } catch {
                if (completedBlock != nil) {
                    completedBlock!(nil, error)
                }
            }

        }
        
    }
    
    
    /// 对于搜索结果的内容匹配，编辑距离算法
    /// - Parameters:
    ///   - json: 搜索id返回的json
    ///   - original: spotify的单曲item
    private func screenData(json: WYMusicJSON, original: Track_Full) -> Int? {
        var minDistances = [Int:WYMusicSong]()
        
        let originalName = (original.name?.convert() ?? "")+" "+(original.album?.name?.convert() ?? "")

        
        var destinationName = ""
        guard let songs = json.result?.songs else {
            return nil
        }
        for item in songs.reversed() {
            if original.artists?.first?.name?.convert().lowercased() == item.artists?.first?.name?.lowercased() {
                destinationName = (item.name ?? "")+" "+(item.album?.name ?? "")
                minDistances.updateValue(item, forKey: minDistance(originalName, destinationName))
            }

        }
        
        let key = minDistances.keys.sorted().first ?? 0
        return minDistances[key]?.id ?? nil

    }
    
    
    /// 编辑距离算法，用于文本相似度匹配, 返回将 word1 转换成 word2 所使用的最少操作数
    /// - Parameters:
    ///   - word1: 文本1
    ///   - word2: 文本2
    fileprivate func minDistance(_ word1: String, _ word2: String) -> Int {
         if word1.count == 0 {
             return word2.count
         }
         if word2.count == 0 {
             return word1.count
        }
        
        let c1 = Array(word1)
        let c2 = Array(word2)
        var cache = [[Int]](repeating: [Int](repeating: -1, count: c2.count), count: c1.count)
        
        return match(c1, c2, 0, 0, &cache)
    }

    fileprivate func match(_ c1: [Character], _ c2: [Character], _ i: Int, _ j: Int, _ cache: inout [[Int]]) -> Int {
        if c1.count == i {
            return c2.count - j
        }
        if c2.count == j {
            return c1.count - i
        }
        if cache[i][j] != -1 {
            return cache[i][j]
        }
        
        if c1[i] == c2[j] {
            cache[i][j] = match(c1, c2, i + 1, j + 1, &cache)
        } else {
            let insert = match(c1, c2, i, j + 1, &cache)
            let delete = match(c1, c2, i + 1, j, &cache)
            let replace = match(c1, c2, i + 1, j + 1, &cache)
            
            cache[i][j] = min(min(insert, delete), replace) + 1
        }
        return cache[i][j]
    }
    
    
    private func handleDataForMusicUrls(json: WYMusicDataJSON, original: [Int:Int]) -> [Int:WYSongData]? {
        
        var results:[Int:WYSongData]?

        guard let datas = json.data else {
            return nil
        }
        if original.count == 0 || datas.count != original.count {
            return nil
        } else {
            let keys = Array(original.keys)
            results = [:]
            for i in 0...original.count-1 {
                for j in 0...original.count-1 {
                    if datas[i].url != nil && datas[i].id == original[keys[j]] {
                        results?.updateValue(datas[i], forKey: keys[j])
                    }
                }
            }
            return results
        }
        
        
        
            
            
            
    }
    
    
    /// 获取音乐表单中的url
    /// - Parameters:
    ///   - items: items
    ///   - completedBlock: 完成返回Block，返回[offest :  json]的字典，error
    func getMusicUrls(items: [Track_Full], completedBlock: JLGetMusicUrlsCompletionBlock?) {
        searchIds(items: items) { (ids) in
            if !(ids ?? [:]).isEmpty {
                let urlString = "http://developer.iscuec.club:3000/song/url"
                var songidsString = ""
                let keys = ids!.keys.sorted()
                for i in 0...keys.count-1 {
                    if i == 0 {
                        songidsString = songidsString + String(ids![keys[i]]!)
                    } else {
                        songidsString = songidsString + "," + String(ids![keys[i]]!)
                    }
                }
                let paras = ["id":songidsString,"br":"320000"]
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
                        
                        if (completedBlock != nil) {
                            completedBlock!(nil)
                        }
                        return
                    }
                        do {
                            let json = try WYMusicDataJSON.init(data: data)
                            if (completedBlock != nil) {
                                
                                completedBlock!(self.handleDataForMusicUrls(json: json, original: ids!))
                            }
                            
                        } catch {
                            if (completedBlock != nil) {
                                completedBlock!(nil)
                            }
                        }
                }
                
            } else {
                if (completedBlock != nil) {
                    completedBlock!(nil)
                }
            }
        }
    }
    
    
    /// 搜索音乐表单中的url
    /// - Parameters:
    ///   - items: items
    ///   - completedBlock: 返回完成block  ，返回[offset : id],  error
    func searchIds(items:[Track_Full], completedBlock:JLSearchIdsCompletionBlock?) {
        var results: [Int:Int] = [:]
        let group = DispatchGroup()

        for  offset in 0...(items.count-1) {
            group.enter()
            searchId(item: items[offset]) { (id, error) in
                if let result = id {
                    results.updateValue(result, forKey: offset)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            if (completedBlock != nil) {
                completedBlock!(results)
            }

        }
        
        
    }
    
    
    
    
}
