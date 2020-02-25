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


let Library_ArtistCellID = "JLLibraryListTableViewArtistCell"
let Library_AlbumCellID = "JLLibraryListTableViewAlbumCell"
let Library_PlaylistCellID = "JLLibraryListTableViewPlaylistCell"
let Library_SongCellID = "JLLibraryListTableViewSongCell"


class JLLibraryContentTableViewController: UITableViewController {
    let JLLibraryContentType: JLLibraryContentType
    var fetchManagement = JLLibraryFetchManagement()
    let dispose = DisposeBag()
    var jsons:[JLLibraryQuickJSON] = []
    var contentItems = BehaviorRelay<[JLLibraryListSectionItem]>.init(value: [JLLibraryListSectionItem]())
    
    init(style: UITableView.Style, type: JLLibraryContentType) {
        self.JLLibraryContentType = type
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

        switch JLLibraryContentType {
        case .Albums:
            self.tableView.register(UINib.init(nibName: Library_AlbumCellID, bundle: nil), forCellReuseIdentifier: Library_AlbumCellID)
            self.bindData(cellId: Library_AlbumCellID, cellType: JLLibraryListTableViewAlbumCell.self)
            break
        case .Artists:
            self.tableView.register(UINib.init(nibName: Library_ArtistCellID, bundle: nil), forCellReuseIdentifier: Library_ArtistCellID)
            self.bindData(cellId: Library_ArtistCellID, cellType: JLLibraryListTableViewArtistCell.self)
            break
        case .Tracks:
            self.tableView.register(UINib.init(nibName: Library_SongCellID, bundle: nil), forCellReuseIdentifier: Library_SongCellID)
            self.bindData(cellId: Library_SongCellID, cellType: JLLibraryListTableViewSongCell.self)
            break
        case .Playlists:
            self.tableView.register(UINib.init(nibName: Library_PlaylistCellID, bundle: nil), forCellReuseIdentifier: Library_PlaylistCellID)
            self.bindData(cellId: Library_PlaylistCellID, cellType: JLLibraryListTableViewPlaylistCell.self)
            break

        }
        
        YYDispatchQueuePool.init(name: "singeFetchLibrary", queueCount: 10, qos: .userInteractive).queue().async {
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
        self.fetchManagement.fetchMyLibrary(type: self.JLLibraryContentType, isReload: false) { (json, offset, error) in
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
        
        fetchManagement.fetchMyLibrary(type: self.JLLibraryContentType, isReload: false) { (json, offset, error) in

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
        fetchManagement.fetchMyLibrary(type: self.JLLibraryContentType, isReload: true) { (json, offset, error) in
            DispatchQueue.main.async {
                self.tableView.mj_header?.endRefreshing()
                if (json != nil) {
                    self.jsons = [json!]
//                    self.contentItems.accept([])
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
                    (cell as! JLLibraryListTableViewArtistCell).item = aritem
                    (cell as! JLLibraryListTableViewArtistCell).setupUI()
                    
                case .AlbumSectionItem(let alitem):
                    (cell as! JLLibraryListTableViewAlbumCell).item = alitem.album
                    (cell as! JLLibraryListTableViewAlbumCell).setupUI()

                
                case .SongSectionItem(let soitem):
                    (cell as! JLLibraryListTableViewSongCell).item = soitem.track
                    (cell as! JLLibraryListTableViewSongCell).setupUI()

                case .PlaylistSectionItem(let plitem):
                    (cell as! JLLibraryListTableViewPlaylistCell).item = plitem
                    (cell as! JLLibraryListTableViewPlaylistCell).setupUI()


            }
        }.disposed(by: dispose)
    }

    
    func handleJsonData(_ json:JLLibraryQuickJSON) -> [JLLibraryListSectionItem] {
        var items = [JLLibraryListSectionItem]()
        switch json {

        case .Albums(let item):
            for iitem in item.items ?? [] {
                items.append(.AlbumSectionItem(item: iitem))
            }
        case .Artists(let item):
            for iitem in item.artists?.items ?? [] {
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
