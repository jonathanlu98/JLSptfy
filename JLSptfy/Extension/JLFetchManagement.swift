//
//  JLFetchManagement.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit



class JLFetchManagement: NSObject {
    /**
                Optional.
            Maximum number of results to return.
            Default: 20
            Minimum: 1
            Maximum: 50
            Note: The limit is applied within each type, not on the total response.
            For example, if the limit value is 3 and the type is artist,album, the response contains 3 artists and 3 albums.
     */
    public var limit:Int = 20
    /**
                Optional.
            The index of the first result to return.
            Default: 0 (the first result).
            Maximum offset (including limit): 5,000.
            Use with limit to get the next page of search results.
     */
    private var offset:Int = 0
    /**
                Required.
            A comma-separated list of item types to search across.
            Valid types are: album , artist, playlist, and track.
            Search results include hits from all the specified item types.
            For example: q=name:abacab&type=album,track returns both albums and tracks with “abacab” included in their name.
     */
    public var type:JLSearchType = .all
    /**
                拉取的次数，用于搜索单类的时候下拉定位offset
     */
    private var pulls:Int = 0
    
    public var searchText:String = ""
    /**
                用于Library的artist获取，他与其他的get请求的参数不相同
     */
    private var lastFollowedArtistID:String?
    
    
    /**
    Returns the default singleton instance.
    */
    @objc public static let shared = JLFetchManagement()
    


    typealias JLMutiSearchCompletionBlock = (JLSearchQuickJSON?, Error?) -> Void
    
    /**
     返回的值依次为json，offset，error
     */
    typealias JLSearchCompletionBlock = (JLSearchQuickJSON?, Int, Error?) -> Void
    
    
    
    typealias JLLibraryCompletionBlock = (JLLibraryQuickJSON?, Int, Error?) -> Void

    
    override init() {
        super.init()
    }
    
    init(limit:Int, type:JLSearchType) {
        super.init()
        self.limit = limit
        self.type = type
    }
    /**
        用于首次搜索的方法，其中market无限制，limit为5，type为track,artist,album,playlist
     */
    func mutiSearch(text:String, completed completedBlock: JLMutiSearchCompletionBlock?)  {
        self.searchText = text
        let semaphore = DispatchSemaphore (value: 0)

        let urlString = "https://api.spotify.com/v1/search?"+"q="+text+"&type=track,artist,album,playlist"+"&limit="+String(5)+"&offset=0"
        
        var request = URLRequest(url: URL.initPercent(string: urlString),timeoutInterval: Double.infinity)
        request.addValue("Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? ""), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                if (completedBlock != nil) {
                    completedBlock!(nil,error)
                }
                return
            }

            do {
                let json = try JLSearchQuickJSON.init(data: data)
                if (completedBlock != nil) {
                    completedBlock!(json,nil)
                }

            } catch {
                print(error)
                if (completedBlock != nil) {
                    completedBlock!(nil,error)
                }
            }
            
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    func singleSearch(text:String, type:JLSearchType, completed completedBlock: JLSearchCompletionBlock?) {
        self.searchText = text
        let oldOffset = self.offset
        self.offset = pulls*limit
        let semaphore = DispatchSemaphore (value: 0)
        let urlString = "https://api.spotify.com/v1/search?"+"q="+text+"&type="+type.description()+"&limit="+String(self.limit)+"&offset="+String(self.offset)
        
        var request = URLRequest(url: URL.initPercent(string: urlString),timeoutInterval: Double.infinity)
        request.addValue("Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? ""), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                if (completedBlock != nil) {
                    print(error)
                    self.offset = oldOffset
                    completedBlock?(nil, self.offset, error)
                }
                return
            }

            do {
                let json = try JLSearchQuickJSON.init(data: data)
                if (completedBlock != nil) {
                    self.pulls += 1
                    completedBlock!(json, self.offset, nil)
                }

            } catch {
                print(error)
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    completedBlock!(nil, self.offset, error)
                }
            }
            
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    func fetchMyLibrary(type: ContentType, isReload: Bool, completed completedBlock: JLLibraryCompletionBlock?) {
        let oldOffset = self.offset
        let oldLastFollowedArtistID = self.lastFollowedArtistID

        if isReload == true {
            self.lastFollowedArtistID = nil
            self.offset = 0
        } else {
            
            self.offset = pulls*limit
        }
        
        
        let semaphore = DispatchSemaphore (value: 0)
        var urlString = ""
        if type == .Artists {
            if self.lastFollowedArtistID != nil {
            urlString = "https://api.spotify.com/v1/me/following"+"?type=artist"+"&limit="+String(self.limit)+"&after="+self.lastFollowedArtistID!
            } else {
                urlString = "https://api.spotify.com/v1/me/following"+"?type=artist"+"&limit="+String(self.limit)
            }

        } else {
            urlString = "https://api.spotify.com/v1/me/"+type.description()+"?limit="+String(self.limit)+"&offset="+String(self.offset)
        }
        var request = URLRequest(url: URL.initPercent(string: urlString),timeoutInterval: Double.infinity)
        request.addValue("Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? ""), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                if (completedBlock != nil) {
                    print(error)
                    self.offset = oldOffset
                    self.lastFollowedArtistID = oldLastFollowedArtistID
                    completedBlock?(nil, self.offset, error)
                }
                return
            }
//            print(String(data: data, encoding: .utf8)!)
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
//                print(json!)
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
                print(error)
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    self.lastFollowedArtistID = oldLastFollowedArtistID
                    completedBlock!(nil, self.offset, error)
                }
            }
            
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
}




extension URL{
    
    static func initPercent(string:String) -> URL
    {
        let urlwithPercentEscapes = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: urlwithPercentEscapes!)
        return url!
    }
}


