//
//  JLLibraryListTableViewAlbumCell.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/7.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit


class JLLibraryListTableViewAlbumCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    var item: Album_Full!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView.init(frame: self.frame)
        self.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037510702)
        
//        titleLabel.speed = .rate(60)
//        titleLabel.fadeLength = 10.0
//        titleLabel.type = .leftRight
        // Initialization code
    }
    
    func setupUI() {
        self.titleLabel.text = item.name
        self.subTitleLabel.text! = (item.artists?.first?.name ?? "-")
        fetchImage(URL(string: item.images?.last?.url ?? ""), imageView: self.iconImageView)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
