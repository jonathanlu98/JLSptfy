//
//  JLNavigationViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/7.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

class JLNavigationViewController: UINavigationController {

    let backitem: UIBarButtonItem = {
        let item = UIBarButtonItem.init()
        item.image = UIImage.init(systemName: "chevron.left")
        item.tintColor = #colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.barStyle = .black
        self.navigationBar.shadowImage = UIImage()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
