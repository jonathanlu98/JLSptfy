//
//  JLSearchListTableViewArtistCell.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/5.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

//enum ItemType {
//    case Track
//    case Playlist
//    case Album
//    case Artist
//}



class JLSearchListTableViewArtistCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var item: Artist_Full!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
//    var itemType: ItemType!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        self.selectedBackgroundView = UIView.init(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037510702)
        
//        titleLabel.type = .leftRight


    

        // Initialization code
        
        
    }
    
    func setupUI() {
        

        self.titleLabel.text = item.name
        fetchImage(URL.init(string: self.item.images?.last?.url ?? ""), imageView: iconImageView)

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



