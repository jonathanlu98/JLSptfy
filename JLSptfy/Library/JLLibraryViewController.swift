//
//  JLLibraryViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/13.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JLLibraryViewController: UIViewController {

    let dispose = DisposeBag()
    
    @IBOutlet weak var pageTitleView: PageTitleView!
    
    @IBOutlet weak var pageContentView: PageContentView!
    
    var pageManager: PageViewManager!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
    //        self.navigationBarExtraView.isHidden = false
    //        self.navigationBarPlayerMenuView.isHidden = false

        }
        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            self.navigationController?.navigationBar.isHidden = false
//    //        self.navigationBarExtraView.isHidden = true
//    //        self.navigationBarPlayerMenuView.isHidden = true
//
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageView()
        

        
        
        // Do any additional setup after loading the view.
    }
    
    
    private func setupPageView() {
        let style = PageStyle()
        style.titleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        style.titleSelectedColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        style.titleViewBackgroundColor = .clear
        style.bottomLineColor = #colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)
        style.bottomLineHeight = 2
        style.bottomLineWidth = pageTitleView.frame.width/3
        style.isShowBottomLine = false
        style.titleFont = .systemFont(ofSize: 18, weight: .semibold)
        style.isShowCoverView = false
        
        pageTitleView.titles = ["Playlists","Artists","Albums","Songs"]
        pageTitleView.style = style
        pageTitleView.currentIndex = 0

        pageTitleView.setupUI()

        
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = ["Playlists","Artists","Albums","Songs"].map { string -> UIViewController in
            switch string {
                case "Playlists":
                    let controller = JLLibraryContentTableViewController.init(style: .grouped, type: .Playlists)
                    addChild(controller)
                    return controller
                case "Artists":
                    let controller = JLLibraryContentTableViewController.init(style: .grouped, type: .Artists)
                    addChild(controller)
                    return controller
                case "Albums":
                    let controller = JLLibraryContentTableViewController.init(style: .grouped, type: .Albums)
                    addChild(controller)
                    return controller
                case "Songs":
                    let controller = JLLibraryContentTableViewController.init(style: .grouped, type: .Tracks)
                    addChild(controller)
                    return controller

                default:
                let controller = UIViewController()
                addChild(controller)
                return controller
            }

        }

        
        pageContentView.childViewControllers = childViewControllers

        pageContentView.style = style
        pageContentView.currentIndex = 0
        pageContentView.setupUI()
        pageContentView.collectionView.backgroundColor = .clear
        pageTitleView.delegate = pageContentView
        pageContentView.delegate = pageTitleView
    }


    @IBAction func MeButtonAction(_ sender: Any) {

        let viewController = JLMeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
