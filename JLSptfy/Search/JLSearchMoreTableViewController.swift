//
//  JLSearchMoreTableViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/7.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import YYKit



class JLSearchMoreTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    /// 搜索关键字
    let searchText:String
    
    /// 搜索类型
    let type:JLSearchType
    
    var searchManagement = JLSearchManagement()
    
    /// json数据
    var jsons:[JLSearchQuickJSON] = []
    
    /// 处理后的数据（RX）
    var data = BehaviorRelay.init(value: [JLSearchListSectionItem]())
    
    let dispose = DisposeBag()
    
    
    
    
    init(style:UITableView.Style, searchText:String, type:JLSearchType) {
        self.searchText = searchText
        self.type = type
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackBar()
        
        handleTableView()
            

    }
    
    /// 添加返回按钮
    private func setupBackBar() {
        let backBarItem = (self.navigationController as! JLNavigationViewController).backitem
        self.navigationItem.setLeftBarButton(backBarItem, animated:true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        backBarItem.rx.tap.subscribe(onNext: { (arg0) in
            let () = arg0
            self.navigationController?.popViewController(animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        self.title = "\""+searchText+"\""+" in "+type.description().capitalized+"s"
    }
    
    
    /// 处理tableview
    private func handleTableView() {
        self.tableView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
        self.tableView.separatorStyle = .none
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        switch type {
        case .album:
            self.tableView.register(UINib.init(nibName: Search_AlbumCellID, bundle: nil), forCellReuseIdentifier: Search_AlbumCellID)
            self.bindData(cellId: Search_AlbumCellID, cellType: JLSearchListTableViewAlbumCell.self)
            break
        case .artist:
            self.tableView.register(UINib.init(nibName: Search_ArtistCellID, bundle: nil), forCellReuseIdentifier: Search_ArtistCellID)
            self.bindData(cellId: Search_ArtistCellID, cellType: JLSearchListTableViewArtistCell.self)
            break
        case .track:
            self.tableView.register(UINib.init(nibName: Search_SongCellID, bundle: nil), forCellReuseIdentifier: Search_SongCellID)
            self.bindData(cellId: Search_SongCellID, cellType: JLSearchListTableViewSongCell.self)
            break
        case .playlist:
            self.tableView.register(UINib.init(nibName: Search_PlaylistCellID, bundle: nil), forCellReuseIdentifier: Search_PlaylistCellID)
            self.bindData(cellId: Search_PlaylistCellID, cellType: JLSearchListTableViewPlaylistCell.self)
            break
        case .all: break

        }


        YYDispatchQueuePool.init(name: "singeSearch", queueCount: 10, qos: .userInteractive).queue().async {
            self.getData()
        }
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            YYDispatchQueuePool.init(name: "searchPulldata", queueCount: 10, qos: .userInteractive).queue().async {
                self.pullData()
            }
            
        })
        self.tableView.mj_footer?.isHidden = true
    }
    
    /// 下拉拉取数据
    private func pullData() {
        self.searchManagement.singleSearch(text: self.searchText, type: self.type) { (json, offset, error) in
            DispatchQueue.main.async {
                if (json != nil) {
                    self.tableView.mj_footer?.endRefreshing()
                    self.jsons.append(json!)
                    let items = self.handleJsonData(json!)
                    if items.count < self.searchManagement.limit {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    Observable.just(items).delay(TimeInterval(0.2), scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { (items) in
                        self.data.accept(self.data.value + items)
                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                    
                } else {
                    self.tableView.mj_footer?.endRefreshing()
                }
            }
        }
    }
    
    /// 获取数据
    private func getData() {
        
        searchManagement.singleSearch(text: searchText, type: type) { (json, offset, error) in

            DispatchQueue.main.async {
                if (json != nil) {
                    self.jsons.append(json!)
                    Observable
                        .just(
                            self.handleJsonData(json!)
                        )
                        .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
                        .asDriver(onErrorDriveWith: Driver.empty()).drive(self.data).disposed(by: self.dispose)
                    self.tableView.mj_footer?.isHidden = false
                }
            }
        }
    }
    

    
    /// 绑定数据（RX）
    /// - Parameters:
    ///   - cellId: cell的id
    ///   - cellType: cell种类
    private func bindData(cellId:String, cellType:UITableViewCell.Type) {
        self.data.bind(to: self.tableView.rx.items(cellIdentifier: cellId, cellType: cellType)) {index,item,cell in
            switch item {
                
                case .ArtistSectionItem(let aritem):
                    (cell as! JLSearchListTableViewArtistCell).item = aritem
                    (cell as! JLSearchListTableViewArtistCell).setupUI()
                    
                case .AlbumSectionItem(let alitem):
                    (cell as! JLSearchListTableViewAlbumCell).item = alitem
                    (cell as! JLSearchListTableViewAlbumCell).setupUI()

                
                case .SongSectionItem(let soitem):
                    (cell as! JLSearchListTableViewSongCell).item = soitem
                    (cell as! JLSearchListTableViewSongCell).setupUI()
                    
                case .PlaylistSectionItem(let plitem):
                    (cell as! JLSearchListTableViewPlaylistCell).item = plitem
                    (cell as! JLSearchListTableViewPlaylistCell).setupUI()

                case .MoreSectionItem( _): break

            }
        }.disposed(by: dispose)
        
        self.tableView.rx.modelSelected(JLSearchListSectionItem.self).subscribe(onNext: { (item) in
            switch item {
                
            case .ArtistSectionItem(let item):
                break
            case .AlbumSectionItem(let item):
                break
            case .SongSectionItem(let item):
                DispatchQueue.init(label: "playQueue").async {
                    JLMusicFetchManagement.shared.getMusicUrl(item: item) { (json, error) in
                        if (json != nil) {
                            DispatchQueue.main.async {

                                let viewController = JLPlayerViewController.init(item: .init(item: item, wySongUrl: URL.init(string: (json!.url)!)!, wySongId: (json!.id)!))
                                (AppDelegate.sharedInstance.window?.rootViewController as! JLTabBarController).present(viewController, animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.presentAlertController(title: "Error", message: error?.localizedDescription ?? "", buttonTitle: "Ok")
                            }

                        }
                    }
                }
            case .PlaylistSectionItem(let item):
                break
            @unknown default:
                break
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }

    
    /// 处理json数据
    /// - Parameter json: json
    private func handleJsonData(_ json:JLSearchQuickJSON) -> [JLSearchListSectionItem] {
        var items = [JLSearchListSectionItem]()
        switch type {

        case .album:
            for item in json.albums?.items ?? [] {
                items.append(.AlbumSectionItem(item: item))
            }
        case .artist:
            for item in json.artists?.items ?? [] {
                items.append(.ArtistSectionItem(item: item))
            }
        case .track:
            for item in json.tracks?.items ?? [] {
                items.append(.SongSectionItem(item: item))
            }
        case .playlist:
            for item in json.playlists?.items ?? [] {
                items.append(.PlaylistSectionItem(item: item))
            }
        case .all: break
        }
        
        
        return items
        
    }

}

extension JLSearchMoreTableViewController {
    /*解决向右的返回*/
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count ?? 0 <= 1 {
            return false
        } else {
            return true
        }
    }
}
