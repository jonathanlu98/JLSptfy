//
//  JLTabBarController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2019/3/21.
//  Copyright © 2019 JonathanLu. All rights reserved.
//

import UIKit
import RxSwift

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

class JLTabBarController: UITabBarController {
    
    let dispose = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)

        self.loadViewControllers()
        

    }
    
    
    /// 加载viewControllers
    private func loadViewControllers() {
        
        let vc1 = JLHomeViewController()
        vc1.title = ""
        let nc1 = JLNavigationViewController.init(rootViewController: vc1)
        config(tabBarItem: vc1.tabBarItem, title: "Home", image: #imageLiteral(resourceName: "home-o"), selectedImage: #imageLiteral(resourceName: "home"), textColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), selectedTextColor: .white, textFont: UIFont.systemFont(ofSize: 11))
        
        let vc2 = JLSearchViewController()
        vc2.title = ""
        let nc2 = JLNavigationViewController.init(rootViewController: vc2)
        config(tabBarItem: vc2.tabBarItem, title: "Search", image: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search-o"), textColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), selectedTextColor: .white, textFont: UIFont.systemFont(ofSize: 11))
        
        let vc3 = JLLibraryViewController()
        let nc3 = JLNavigationViewController.init(rootViewController: vc3)
        config(tabBarItem: vc3.tabBarItem, title: "Your Library", image: #imageLiteral(resourceName: "align-right 0"), selectedImage: #imageLiteral(resourceName: "align-right"), textColor: #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1), selectedTextColor: .white, textFont: UIFont.systemFont(ofSize: 11))

        
        self.addChild(nc1)
        self.addChild(nc2)
        self.addChild(nc3)
        
    }
    
    /// 配置tabBarItem
    /// - Parameters:
    ///   - tabBarItem: viewController中的tabbarItem
    ///   - title: 名字
    ///   - image: 图片
    ///   - selectedImage: 选中u图片
    ///   - textColor: 字体颜色
    ///   - selectedTextColor: 选中字体颜色
    ///   - textFont: 字体样式
    private func config(tabBarItem:UITabBarItem, title:String, image:UIImage ,selectedImage:UIImage ,textColor:UIColor, selectedTextColor:UIColor, textFont:UIFont) {
        tabBarItem.title = title
        tabBarItem.image = image
        tabBarItem.selectedImage = selectedImage
        let attr = NSMutableDictionary()
        attr[NSAttributedString.Key.font] = textFont
        attr[NSAttributedString.Key.foregroundColor] = textColor
        
        let selectedAttr = NSMutableDictionary()
        selectedAttr[NSAttributedString.Key.font] = textFont
        selectedAttr[NSAttributedString.Key.foregroundColor] = selectedTextColor
        
        tabBarItem.setTitleTextAttributes((attr as! [NSAttributedString.Key : Any]), for: .normal)
        tabBarItem.setTitleTextAttributes((selectedAttr as! [NSAttributedString.Key : Any]), for: .selected)
        
    }


}




