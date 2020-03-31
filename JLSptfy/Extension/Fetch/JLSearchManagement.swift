//
//  JLSearchManagement.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import Alamofire


class JLSearchManagement: NSObject {
    /**
     每次搜索限制的个数。如果type为多个，则每个类型返回该限制次数
     */
    public var limit:Int = 20
    /**
     在该搜索结果下的索引值。配合limit可实现翻页效果
     */
    private(set) var offset:Int = 0
    /**
     搜索类型。
     */
    private(set) var type:JLSearchType = .all
    /**
     拉取的次数，用于搜索单类的时候下拉定位offset
     */
    private(set) var pulls:Int = 0
    /**
     搜索的内容
     */
    private(set) var searchText:String = ""
    
    
    
    /**
     Returns the default singleton instance.
    */
    @objc public static let shared = JLSearchManagement()
    


    typealias JLMutiSearchCompletionBlock = (JLSearchQuickJSON?, Error?) -> Void
    
    
    typealias JLSearchCompletionBlock = (JLSearchQuickJSON?, Int, Error?) -> Void
    


    
    override init() {
        super.init()
    }
    
    
    init(limit:Int, type:JLSearchType) {
        super.init()
        self.limit = limit
        self.type = type
    }
    /**
     用于首次综合搜索的方法
     
     - Parameter text: 搜索关键字
     - Parameter completed: 完成返回Block，返回json，error
    */
    func mutiSearch(text:String, completed completedBlock: JLMutiSearchCompletionBlock?)  {
        self.searchText = text
        self.type = .all

        let urlString = "https://api.spotify.com/v1/search"
        let paras = ["q":text,"type":"track,artist,album,playlist","limit":"5","offset":"0"] as [String : String]
        let headers: HTTPHeaders = ["Authorization":"Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? "")]
        
        
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            guard let data = response.data else {
                if (completedBlock != nil) {
                    completedBlock!(nil,response.error)
                }
                return
            }

            do {
                let json = try JLSearchQuickJSON.init(data: data)
                if (completedBlock != nil) {
                    completedBlock!(json,nil)
                    
                }

            } catch {
                if (completedBlock != nil) {
                    completedBlock!(nil,error)
                }
            }
        }

    }
    
    
    
    /**
     用于单个搜索的方法
     
     - Parameter text: 搜索关键字
     - Parameter type: 搜索类型
     - Parameter completed: 完成返回Block，返回json，offset，error
    */
    func singleSearch(text:String, type:JLSearchType, completed completedBlock: JLSearchCompletionBlock?) {
        self.searchText = text
        self.type = type
        
        let oldOffset = self.offset
        self.offset = pulls*limit
        
        let urlString = "https://api.spotify.com/v1/search"
        let paras = ["q":text,"type":type.description(),"limit":String(self.limit),"offset":String(self.offset)] as [String : String]
        let headers: HTTPHeaders = ["Authorization":"Bearer " + (UserDefaults.standard.string(forKey: "accessToken") ?? "")]
        
        Alamofire.request(urlString, method: .get, parameters: paras, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            
            guard let data = response.data else {
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    completedBlock?(nil, self.offset, response.error)
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
                if (completedBlock != nil) {
                    self.offset = oldOffset
                    completedBlock!(nil, self.offset, error)
                }
            }
            
        }
    }
    
    
    

    
    
    
    
    
}







