//
//  JLLibraryListTableViewPlaylistCell.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/6.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit


class JLLibraryListTableViewPlaylistCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    var item: Playlist_Simplified!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView.init(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037510702)
        
//        titleLabel.speed = .rate(CGFloat(0.60))
//        titleLabel.fadeLength = 10.0
//        titleLabel.type = .leftRight
        // Initialization code
    }
    
    func setupUI() {
        
        self.titleLabel.text = item.name
        self.subTitleLabel.text = "by " + (item.owner?.id ?? "-")
        fetchImage(URL(string: item.images?.last?.url ?? ""), imageView: iconImageView)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
