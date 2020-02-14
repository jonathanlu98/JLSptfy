//
//  JLLibraryContentTableViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/14.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh
import YYKit

class JLLibraryContentTableViewController: UITableViewController {
    let contentType: ContentType
    var fetchManagement = JLFetchManagement()
    let dispose = DisposeBag()
    var jsons:[JLLibraryQuickJSON] = []
    var contentItems = BehaviorRelay<[JLListSectionItem]>.init(value: [JLListSectionItem]())
    
    init(style: UITableView.Style, type: ContentType) {
        self.contentType = type
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil

        switch contentType {
        case .Albums:
            self.tableView.register(UINib.init(nibName: albumCellID, bundle: nil), forCellReuseIdentifier: albumCellID)
            self.bindData(cellId: albumCellID, cellType: JLSearchListTableViewAlbumCell.self)
            break
        case .Artists:
            self.tableView.register(UINib.init(nibName: artistCellID, bundle: nil), forCellReuseIdentifier: artistCellID)
            self.bindData(cellId: artistCellID, cellType: JLSearchListTableViewArtistCell.self)
            break
        case .Tracks:
            self.tableView.register(UINib.init(nibName: songCellID, bundle: nil), forCellReuseIdentifier: songCellID)
            self.bindData(cellId: songCellID, cellType: JLSearchListTableViewSongCell.self)
            break
        case .Playlists:
            self.tableView.register(UINib.init(nibName: playlistCellID, bundle: nil), forCellReuseIdentifier: playlistCellID)
            self.bindData(cellId: playlistCellID, cellType: JLSearchListTableViewPlaylistCell.self)
            break

        }
        
        YYDispatchQueuePool.init(name: "singeSearch", queueCount: 10, qos: .userInteractive).queue().async {
            self.getData()
        }
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            YYDispatchQueuePool.init(name: "libraryPulldata", queueCount: 10, qos: .userInteractive).queue().async {
                self.pullData()
            }
            
        })
        self.tableView.mj_footer?.isHidden = true
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            YYDispatchQueuePool.init(name: "libraryPulldata", queueCount: 10, qos: .userInteractive).queue().async {
                self.refreshData()
            }
        })
        self.tableView.mj_header?.isHidden = true

    }

    func pullData() {
        self.fetchManagement.fetchMyLibrary(type: self.contentType, isReload: false) { (json, offset, error) in
            DispatchQueue.main.async {
                if (json != nil) {
                    self.tableView.mj_footer?.endRefreshing()
                    self.jsons.append(json!)
                    let items = self.handleJsonData(json!)
                    if items.count < self.fetchManagement.limit {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    Observable.just(items).delay(TimeInterval(0.2), scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty()).drive(onNext: { (items) in
                        self.contentItems.accept(self.contentItems.value + items)
                    }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                    
                } else {
                    self.tableView.mj_footer?.endRefreshing()
                    
                }
            }
        }

    }
        
    func getData() {
        
        fetchManagement.fetchMyLibrary(type: self.contentType, isReload: false) { (json, offset, error) in

            DispatchQueue.main.async {
                if (json != nil) {
                    self.jsons.append(json!)
                    Observable
                        .just(
                            self.handleJsonData(json!)
                        )
                        .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
                        .asDriver(onErrorDriveWith: Driver.empty()).drive(self.contentItems).disposed(by: self.dispose)
                    self.tableView.mj_footer?.isHidden = false
                    self.tableView.mj_header?.isHidden = false
                } else {
                    self.tableView.mj_header?.isHidden = false
                }
            }
        }
    }
    
    func refreshData() {
        fetchManagement.fetchMyLibrary(type: self.contentType, isReload: true) { (json, offset, error) in
            DispatchQueue.main.async {
                self.tableView.mj_header?.endRefreshing()
                if (json != nil) {
                    self.jsons = [json!]
                    self.contentItems = BehaviorRelay<[JLListSectionItem]>.init(value: [])
                    Observable
                        .just(
                            self.handleJsonData(json!)
                        )
                        .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
                        .asDriver(onErrorDriveWith: Driver.empty()).drive(self.contentItems).disposed(by: self.dispose)
                    self.tableView.mj_footer?.isHidden = false
                    
                }
            }
        }
    }
    
    
    func bindData(cellId:String, cellType:UITableViewCell.Type) {
        self.contentItems.bind(to: self.tableView.rx.items(cellIdentifier: cellId, cellType: cellType)) {index,item,cell in
            switch item {
                
                case .ArtistSectionItem(let aritem):
                    (cell as! JLSearchListTableViewArtistCell).item = aritem
                    (cell as! JLSearchListTableViewArtistCell).viewWithTag(505)?.isHidden = true
                    (cell as! JLSearchListTableViewArtistCell).setupUI()
                    
                case .AlbumSectionItem(let alitem):
                    (cell as! JLSearchListTableViewAlbumCell).item = alitem
                    (cell as! JLSearchListTableViewAlbumCell).setupUI()

                
                case .SongSectionItem(let soitem):
                    (cell as! JLSearchListTableViewSongCell).item = soitem
                    (cell as! JLSearchListTableViewSongCell).viewWithTag(506)?.isHidden = true
                    (cell as! JLSearchListTableViewSongCell).setupUI()

                case .PlaylistSectionItem(let plitem):
                    (cell as! JLSearchListTableViewPlaylistCell).item = plitem
                    (cell as! JLSearchListTableViewPlaylistCell).setupUI()

                case .MoreSectionItem( _): break

            }
        }.disposed(by: dispose)
    }

    
    func handleJsonData(_ json:JLLibraryQuickJSON) -> [JLListSectionItem] {
        var items = [JLListSectionItem]()
        switch json {

        case .Albums(let item):
            for iitem in item.items ?? [] {
                items.append(.AlbumSectionItem(item: iitem))
            }
        case .Artists(let item):
            for iitem in item.items ?? [] {
                items.append(.ArtistSectionItem(item: iitem))
            }
        case .Songs(let item):
            for iitem in item.items ?? [] {
                items.append(.SongSectionItem(item: iitem))
            }
        case .Playlists(let item):
            for iitem in item.items ?? [] {
                items.append(.PlaylistSectionItem(item: iitem))
            }
        case .none: break
        }
        
        
        return items
        
    }




}
