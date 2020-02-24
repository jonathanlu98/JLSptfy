//
//  JLMeViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/22.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JLMeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dispose = DisposeBag()
    
    let items: Observable<[JLMeTableViewCellType]> = Observable.just([.spotify, .wangyiyun])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "JLMeTableViewCell", bundle: nil), forCellReuseIdentifier: "JLMeTableViewCell")
        
        items.bind(to: self.tableView.rx.items(cellIdentifier: "JLMeTableViewCell", cellType: JLMeTableViewCell.self)) { index,item,cell in
            
            cell.setupCell(item)
            
        }.disposed(by: dispose)
        
        
        
        
        
        // Do any additional setup after loading the view.
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
