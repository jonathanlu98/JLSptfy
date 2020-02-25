//
//  JLPlayerProgressView.swift
//  JLSptfy
//
//  Created by Jonathan Lu on 2020/2/24.
//  Copyright © 2020 Jonathan Lu. All rights reserved.
//

import UIKit
import Masonry

protocol JLPlayerProgressViewDelegate: AnyObject {
    func progressView(_ progressView: JLPlayerProgressView, didChanged currentTime: Float64)
}

class JLPlayerProgressView: UIView {
    public weak var delegate: JLPlayerProgressViewDelegate?
    private(set) public var isDraggingSlider: Bool = false

    private var progressSlider: UISlider = {
        let slider = UISlider()
        let thumbImage = UIImage.init(systemName: "circle.fill")
        slider.setThumbImage(thumbImage?.byResize(to: .init(width: 10, height: 10))?.withTintColor(#colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)), for: .normal)
        slider.tintColor = #colorLiteral(red: 0.1137254902, green: 0.8392156863, blue: 0.3764705882, alpha: 1)
        slider.setThumbImage(thumbImage, for: .highlighted)
        slider.setThumbImage(thumbImage, for: .selected)
//        slider.addTarget(self, action: #selector(handleSliderValueChanged(_:event:)), for: .touchDragInside)
        slider.addTarget(self, action: #selector(handleSliderValueChanged(_:event:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(handleSliderTouchUp(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(handleSliderTouchUp(_:)), for: .touchUpOutside)
        return slider
    }()
    private var minTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        label.textAlignment = .left
        label.text = "--:--"
        return label
    }()
    private var maxTimeLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        label.textAlignment = .right
        label.text = "--:--"
        return label
    }()
    private var progressSliderOriginalBounds: CGRect?
    private var shouldIgnoreProgress: Bool = false

    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubviews()
//        ListenerCenter.shared.addListener(listener: self, type: .playerStatusEvent)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        ListenerCenter.shared.addListener(listener: self, type: .playerStatusEvent)
    }
    

    
    deinit {
        ListenerCenter.shared.removeAllListener(listener: self)
    }
    
    private func addSubviews() {
        addSubview(progressSlider)
        
        progressSlider.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self.mas_leading)
            make?.trailing.equalTo()(self.mas_trailing)
            make?.top.equalTo()(self.mas_top)
            make?.height.offset()(29)
        }

        addSubview(minTimeLabel)
        minTimeLabel.mas_makeConstraints { (make) in
            make?.leading.equalTo()(self.mas_leading)
            make?.bottom.equalTo()(self.mas_bottom)
            make?.height.offset()(16)
            make?.width.offset()(42)
        }

        addSubview(maxTimeLabel)
        maxTimeLabel.mas_makeConstraints { (make) in
            make?.trailing.equalTo()(self.mas_trailing)
            make?.bottom.equalTo()(self.mas_bottom)
            make?.height.offset()(16)
            make?.width.offset()(42)
        }

    }

    
    
    public func reset() {
        minTimeLabel.text = "00:00"
        maxTimeLabel.text = "--:--"
        progressSlider.value = 0
    }
    
    public func update(currentTime: Float64, totalTime: Float64) {
        guard currentTime >= 0 && totalTime >= 0 && totalTime >= currentTime else { return }

        if isDraggingSlider || shouldIgnoreProgress {
            return
        }

        minTimeLabel.text = minuteAndSecondStr(second: currentTime)
        maxTimeLabel.text = minuteAndSecondStr(second: totalTime)
        progressSlider.value = Float(currentTime)
        progressSlider.maximumValue = Float(totalTime)
    }


}

// MARK: - Actions

extension JLPlayerProgressView {

    @objc private func handleSliderValueChanged(_ slider: UISlider, event: UIEvent) {
        isDraggingSlider = true
        minTimeLabel.text = minuteAndSecondStr(second: Float64(slider.value))
    }

    @objc private func handleSliderTouchUp(_ slider: UISlider) {
        delegate?.progressView(self, didChanged: Float64(slider.value))
        isDraggingSlider = false
    }

}


// MARK: - Utils

extension JLPlayerProgressView {

    /// 02:30
    func minuteAndSecondStr(second: Float64) -> String {
        let str = String(format: "%02ld:%02ld", Int64(second / 60), Int64(second.truncatingRemainder(dividingBy: 60)))

        return str
    }

}


// MARK: - PlayerStatusListenerProtocol

extension JLPlayerProgressView: PlayerControllerEventListenerProtocol {

    func onPlayerControllerEventDetected(event: PlayerControllerEventType) {
        shouldIgnoreProgress = event != .playing
    }

}
