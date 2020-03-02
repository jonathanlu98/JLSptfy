//
//  JLPlayerImageCollectionViewCell.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/27.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit

class JLPlayerImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    var imageUrl: URL?
    var item:JLPlayItem!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fetchImage(_ url:URL?) {
        self.imageUrl = url
        self.imageVIew.fetchImage(url)
        
    }

}
