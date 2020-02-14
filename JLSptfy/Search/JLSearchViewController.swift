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
import YYKit
import RxDataSources


let artistCellID = "JLSearchListTableViewArtistCell"
let albumCellID = "JLSearchListTableViewAlbumCell"
let playlistCellID = "JLSearchListTableViewPlaylistCell"
let songCellID = "JLSearchListTableViewSongCell"
let moreCellID = "JLSearchListTableViewMoreCell"

class JLSearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchManagement = JLFetchManagement.shared
    
    let dispose = DisposeBag()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchListTableView: UITableView!
    fileprivate var json:JLSearchQuickJSON?
    fileprivate var data = BehaviorRelay.init(value: [JLSearchListSection]())
    
    fileprivate var dataSource = RxTableViewSectionedReloadDataSource<JLSearchListSection>(
        //设置单元格
        configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
                
            case .ArtistSectionItem(let aritem):
                let cell = tableView.dequeueReusableCell(withIdentifier: artistCellID,
                for: indexPath) as! JLSearchListTableViewArtistCell
                cell.item = aritem
                cell.setupUI()
                return cell
                
            case .AlbumSectionItem(let alitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: albumCellID,
                for: indexPath) as! JLSearchListTableViewAlbumCell
                cell.item = alitem
                cell.setupUI()
                return cell
            case .SongSectionItem(let soitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: songCellID,
                for: indexPath) as! JLSearchListTableViewSongCell
                cell.item = soitem
                cell.setupUI()
                return cell
                
            case .PlaylistSectionItem(let plitem):
                let cell = tableView.dequeueReusableCell(withIdentifier: playlistCellID,
                for: indexPath) as! JLSearchListTableViewPlaylistCell
                cell.item = plitem
                cell.setupUI()
                return cell
            case .MoreSectionItem(let type):
                let cell = tableView.dequeueReusableCell(withIdentifier: moreCellID,
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
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
    //        self.navigationBarExtraView.isHidden = false
    //        self.navigationBarPlayerMenuView.isHidden = false

        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.navigationController?.navigationBar.isHidden = false
    //        self.navigationBarExtraView.isHidden = true
    //        self.navigationBarPlayerMenuView.isHidden = true

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self

        searchListTableView.register(UINib.init(nibName: artistCellID, bundle: nil), forCellReuseIdentifier: artistCellID)
        searchListTableView.register(UINib.init(nibName: albumCellID, bundle: nil), forCellReuseIdentifier: albumCellID)
        searchListTableView.register(UINib.init(nibName: playlistCellID, bundle: nil), forCellReuseIdentifier: playlistCellID)
        searchListTableView.register(UINib.init(nibName: songCellID, bundle: nil), forCellReuseIdentifier: songCellID)
        searchListTableView.register(UINib.init(nibName: moreCellID, bundle: nil), forCellReuseIdentifier: moreCellID)
        
        self.data.bind(to: self.searchListTableView.rx.items(dataSource: dataSource)).disposed(by: dispose)
        
        searchListTableView.rx.modelSelected(JLListSectionItem.self).subscribe(onNext: { (item) in
            switch item {
                
            case .ArtistSectionItem(let item):
                
                break
                
            case .AlbumSectionItem(let item):
                
                break
                
            case .SongSectionItem(let item):
                
                break
                
            case .PlaylistSectionItem(let item):
                
                break
                
            case .MoreSectionItem(let type, let text):
                let moreViewController = JLSearchMoreTableViewController.init(style: .grouped, searchText: text, type: type)
                
                self.navigationController?.pushViewController(moreViewController, animated: true)
                
                
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
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
    
    func handleSectionData(json: JLSearchQuickJSON, limit: Int, text: String) -> [JLSearchListSection] {
        var sections = [JLSearchListSection]()
        var artistSectionItems = [JLListSectionItem]()
        var albumSectionItems = [JLListSectionItem]()
        var songSectionItems = [JLListSectionItem]()
        var playlistSectionItems = [JLListSectionItem]()
        var moreSectionItems = [JLListSectionItem]()

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

//单元格类型
enum JLListSectionItem {
    case ArtistSectionItem(item: ArtistsItem)
    case AlbumSectionItem(item: AlbumElement)
    case SongSectionItem(item: TracksItem)
    case PlaylistSectionItem(item: PlaylistsItem)
    case MoreSectionItem(type: JLSearchType,text: String)
}
 
//自定义Section
struct JLSearchListSection {
    var header: String
    var items: [JLListSectionItem]
}
 
extension JLSearchListSection : SectionModelType {
    typealias Item = JLListSectionItem
     
    init(original: JLSearchListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
