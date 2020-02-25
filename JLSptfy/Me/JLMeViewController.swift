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
        
        self.tableView.delegate = self

    }


    @IBAction func popButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    

}


extension JLMeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    
}
