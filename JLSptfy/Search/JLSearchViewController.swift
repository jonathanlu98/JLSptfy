//
//  JLSearchViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import PanModal


let Search_ArtistCellID = "JLSearchListTableViewArtistCell"
let Search_AlbumCellID = "JLSearchListTableViewAlbumCell"
let Search_PlaylistCellID = "JLSearchListTableViewPlaylistCell"
let Search_SongCellID = "JLSearchListTableViewSongCell"
let Search_MoreCellID = "JLSearchListTableViewMoreCell"

class JLSearchViewController: UIViewController {
    

    

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchListTableView: UITableView!
    
    
    let searchManagement = JLSearchManagement.shared
    
    /// 获取的json
    fileprivate var json:JLSearchQuickJSON?
    
    /// 处理后的数据（RX）
    fileprivate var data = BehaviorRelay.init(value: [JLSearchListSection]())
    
    /// tableView的数据源（RX）
    fileprivate var dataSource = RxTableViewSectionedReloadDataSource<JLSearchListSection>(
        //设置单元格
        configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
                
            case .ArtistSectionItem(let aritem):
                let cell = tableView.dequeueReusableCell(withIdentifier: Search_ArtistCellID,
                for: indexPath) as! JLSearchListTableViewArtistCell
                cell.item = aritem
                cell.setupUI()
                return cell
                
            case .AlbumSectionItem(let alitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: Search_AlbumCellID,
                for: indexPath) as! JLSearchListTableViewAlbumCell
                cell.item = alitem
                cell.setupUI()
                return cell
            case .SongSectionItem(let soitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: Search_SongCellID,
                for: indexPath) as! JLSearchListTableViewSongCell
                cell.item = soitem
                cell.setupUI()
                return cell
                
            case .PlaylistSectionItem(let plitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: Search_PlaylistCellID,
                for: indexPath) as! JLSearchListTableViewPlaylistCell
                cell.item = plitem
                cell.setupUI()
                return cell
            case .MoreSectionItem(let type):
                let cell = tableView.dequeueReusableCell(withIdentifier: Search_MoreCellID,
                for: indexPath) as! JLSearchListTableViewMoreCell
                cell.titleLabel.text = "See all "+type.type.description()
                cell.type = type.type
                cell.searchText = type.text
                return cell
            }
        },            //设置分区头标题
        titleForHeaderInSection: { ds, index in
            return ds.sectionModels[index].header
        }
    )
    
    let dispose = DisposeBag()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self

        handleTableView()
    }
    
    
    private func handleTableView() {
        
        searchListTableView.register(UINib.init(nibName: Search_ArtistCellID, bundle: nil), forCellReuseIdentifier: Search_ArtistCellID)
        searchListTableView.register(UINib.init(nibName: Search_AlbumCellID, bundle: nil), forCellReuseIdentifier: Search_AlbumCellID)
        searchListTableView.register(UINib.init(nibName: Search_PlaylistCellID, bundle: nil), forCellReuseIdentifier: Search_PlaylistCellID)
        searchListTableView.register(UINib.init(nibName: Search_SongCellID, bundle: nil), forCellReuseIdentifier: Search_SongCellID)
        searchListTableView.register(UINib.init(nibName: Search_MoreCellID, bundle: nil), forCellReuseIdentifier: Search_MoreCellID)
        
        self.data.bind(to: self.searchListTableView.rx.items(dataSource: dataSource)).disposed(by: dispose)
        
        searchListTableView.rx.modelSelected(JLSearchListSectionItem.self).subscribe(onNext: { (item) in
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
                
            case .MoreSectionItem(let type, let text):
                let moreViewController = JLSearchMoreTableViewController.init(style: .grouped, searchText: text, type: type)
                self.navigationController?.pushViewController(moreViewController, animated: true)
                
                
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
    /// 处理获取的json数据
    /// - Parameters:
    ///   - json: json
    ///   - limit: 当前limit
    ///   - text: section文本
    private func handleSectionData(json: JLSearchQuickJSON, limit: Int, text: String) -> [JLSearchListSection] {
        var sections = [JLSearchListSection]()
        var artistSectionItems = [JLSearchListSectionItem]()
        var albumSectionItems = [JLSearchListSectionItem]()
        var songSectionItems = [JLSearchListSectionItem]()
        var playlistSectionItems = [JLSearchListSectionItem]()
        var moreSectionItems = [JLSearchListSectionItem]()

        for item in json.artists?.items ?? [] {
            artistSectionItems.append( .ArtistSectionItem(item: item))
        }
        for item in json.tracks?.items ?? [] {
            songSectionItems.append( .SongSectionItem(item: item))
        }
        for item in json.albums?.items ?? [] {
            albumSectionItems.append( .AlbumSectionItem(item: item))
        }
        for item in json.playlists?.items ?? [] {
            playlistSectionItems.append( .PlaylistSectionItem(item: item))
        }
        
        if json.artists?.items?.count ?? 0 >= limit {
            moreSectionItems.append( .MoreSectionItem(type: .artist, text: text))
        }
        if json.tracks?.items?.count ?? 0 >= limit {
            moreSectionItems.append( .MoreSectionItem(type: .track, text: text))
        }
        if json.albums?.items?.count ?? 0 >= limit {
            moreSectionItems.append( .MoreSectionItem(type: .album, text: text))
        }
        if json.playlists?.items?.count ?? 0 >= limit {
            moreSectionItems.append( .MoreSectionItem(type: .playlist, text: text))
        }
        

        if artistSectionItems.count != 0 {
            sections.append(JLSearchListSection(header: "Artists", items: artistSectionItems))
        }
        if songSectionItems.count != 0 {
            sections.append(JLSearchListSection(header: "Songs", items: songSectionItems))
        }
        if albumSectionItems.count != 0 {
            sections.append(JLSearchListSection(header: "Albums", items: albumSectionItems))
        }
        if playlistSectionItems.count != 0 {
            sections.append(JLSearchListSection(header: "Playlists", items: playlistSectionItems))
        }
        if moreSectionItems.count != 0 {
            sections.append(JLSearchListSection(header: "", items: moreSectionItems))
        }
        
        return sections
    }
    
    

}


//MARK: UISearchBarDelegate

extension JLSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil && searchBar.text != "") {
            let text = searchBar.text!
            DispatchQueue.init(label: "mutiSearch").async {
                
                self.searchManagement.mutiSearch(text: text) { (json, error) in
                    
                    self.json = json
                    DispatchQueue.main.async {
                        if (json != nil) {
                            Observable
                                .just(
                                    self.handleSectionData(json: json!, limit: 5, text: text)
                                )
                                .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
                                .asDriver(onErrorDriveWith: Driver.empty()).drive(self.data).disposed(by: self.dispose)
                        } else {
                            Observable
                            .just(
                                []
                            )
                            .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
                            .asDriver(onErrorDriveWith: Driver.empty()).drive(self.data).disposed(by: self.dispose)
                        }
                    }
                }
            }
        }
    }
    
    
    
}
