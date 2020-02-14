//
//  JLPlayerViewController.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/9.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import MarqueeLabel
import YYKit
import RxSwift
import Masonry

class JLPlayerViewController: UIViewController {
    
    let dispose = DisposeBag()
    
    var naLabel:MarqueeLabel = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.configLabel(font: .boldSystemFont(ofSize: 13), textColor: .white, textAlignment: .center, type: .leftRight)
        return label
    }()
    @IBOutlet weak var naLabelContainerView: UIView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var trackImageContainerView: UIView!
    
    @IBOutlet weak var titleContainerView: UIView!
    
    var titleLabel: MarqueeLabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = "titleLabeltitleLabeltitleLabeltitleLabeltitleLabel"
        label.configLabel(font: .boldSystemFont(ofSize: 24), textColor: .white, textAlignment: .left, type: .leftRight)
        return label
    }()
    
    var artistLabel: UILabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = "artistLabel"
        label.configLabel(font: .systemFont(ofSize: 16, weight: .medium), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7), textAlignment: .left, type: .leftRight)
        return label
    }()
    
    var imageView: UIImageView! = {
        let imageView = UIImageView.init(frame: .zero).shouldCancelAutoresizing(true)
        return imageView
    }()
    
    @IBOutlet weak var leftTimeLabel: UILabel! 
    
    @IBOutlet weak var rightTimeLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        naLabelContainerView.addSubview(naLabel)
        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(artistLabel)
        trackImageContainerView.addSubview(imageView)
        
        let thumbImage = UIImage.init(systemName: "circle.fill")
        slider.setThumbImage(thumbImage?.byResize(to: .init(width: 10, height: 10))?.withTintColor(#colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)), for: .normal)
        slider.setThumbImage(thumbImage, for: .highlighted)
        slider.setThumbImage(thumbImage, for: .selected)

        setLayout()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setLayout() {
        naLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.naLabelContainerView.mas_top)
            make?.bottom.equalTo()(self.naLabelContainerView.mas_bottom)
            make?.leading.equalTo()(self.naLabelContainerView.mas_leading)
            make?.trailing.equalTo()(self.naLabelContainerView.mas_trailing)
        }
        
        imageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.trackImageContainerView.mas_top)
            make?.bottom.equalTo()(self.trackImageContainerView.mas_bottom)
            make?.leading.equalTo()(self.trackImageContainerView.mas_leading)
            make?.trailing.equalTo()(self.trackImageContainerView.mas_trailing)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.titleContainerView.mas_top)
            make?.leading.equalTo()(self.titleContainerView.mas_leading)
            make?.trailing.equalTo()(self.titleContainerView.mas_trailing)
            make?.height.equalTo()(34)
        }
        artistLabel.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.titleContainerView.mas_bottom)
            make?.leading.equalTo()(self.titleContainerView.mas_leading)
            make?.trailing.equalTo()(self.titleContainerView.mas_trailing)
            make?.height.equalTo()(23)
        }
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


