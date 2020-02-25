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
import SDWebImage
import SZAVPlayer

class JLPlayerViewController: UIViewController {
    

    
    var naLabel:MarqueeLabel = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.configLabel(font: .boldSystemFont(ofSize: 13), textColor: .white, textAlignment: .center, type: .leftRight)
        return label
    }()
    @IBOutlet weak var naLabelContainerView: UIView!
    
    @IBOutlet weak var trackImageContainerView: UIView!
    
    @IBOutlet weak var titleContainerView: UIView!
    
    var titleLabel: MarqueeLabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = ""
        label.configLabel(font: .boldSystemFont(ofSize: 24), textColor: .white, textAlignment: .left, type: .leftRight)
        return label
    }()
    
    var artistLabel: UILabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = ""
        label.configLabel(font: .systemFont(ofSize: 16, weight: .medium), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7), textAlignment: .left, type: .leftRight)
        return label
    }()
    
    var imageView: UIImageView! = {
        let imageView = UIImageView.init(frame: .zero).shouldCancelAutoresizing(true)
        return imageView
    }()
    
    @IBOutlet weak var progressView: JLPlayerProgressView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    private lazy var mediaPlayer = AppDelegate.sharedInstance.mediaPlayer
    
    var audios:[JLPlayItem] = []
    
    private var currentAudio: JLPlayItem?
    
    private var isPaused: Bool = false
    private var playerControllerEvent: PlayerControllerEventType = .none {
        didSet {
            ListenerCenter.shared.notifyPlayerControllerEventDetected(event: playerControllerEvent)
        }
    }
    
    let dispose = DisposeBag()
    
    
    init(item: JLPlayItem) {
        self.currentAudio = item
        self.audios = [item]
        super.init(nibName: "JLPlayerViewController", bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        SZAVPlayerCache.shared.setup(maxCacheSize: 1000)

        currentAudio = audios.first
        
        setupUI()
    }
    
    
    
    private func setupUI() {
        naLabelContainerView.addSubview(naLabel)
        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(artistLabel)
        trackImageContainerView.addSubview(imageView)
        
        progressView.delegate = self
        mediaPlayer.delegate = self
        
        setLayout()
        
        updateView()
        
        setupButtonAction()
        
        playAudio()
    }
    
    private func updateView(shouldUpdateContent:Bool = true) {
        guard let audio = currentAudio else {
            return
        }
        
        if shouldUpdateContent {
                imageView.alpha = 0
                self.imageView.sd_setImage(with: URL.init(string: audio.trackItem.album?.images?.first?.url ?? ""), placeholderImage: nil, options: .retryFailed) { (image, error, type, url) in
                    if (image != nil) {
                        UIImageView.animate(withDuration: 0.2) {
                            self.imageView.alpha = 1
                        }
                    } else {
                        UIImageView.animate(withDuration: 0.2) {
                            self.imageView.alpha = 1
                        }
                    }
                }
                
            titleLabel.text = audio.trackItem.name
            var artistsString = ""
            if audio.trackItem.artists != nil {
                for i in 0...(audio.trackItem.artists!.count-1) {
                    if i == 0 {
                        artistsString = artistsString+(audio.trackItem.artists![i].name ?? " ")
                    } else {
                        artistsString = artistsString+"    "+(audio.trackItem.artists![i].name ?? " ")
                    }
                    
                }
                artistLabel.text = artistsString
            }
        }

        
        if let _ = findAudio(currentAudio: audio, findNext: true) {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }

        if let _ = findAudio(currentAudio: audio, findNext: false) {
            previousButton.isEnabled = true
        } else {
            previousButton.isEnabled = false
        }
        
        if playerControllerEvent == .playing {
            playButton.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
        }
        
    }
    
    
    
    private func setLayout() {
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
    
    
    private func setupButtonAction() {
        playButton.addTarget(self, action: #selector(handlePlayBtnClick), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextBtnClick), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(handlePreviousBtnClick), for: .touchUpInside)
    }

}



extension JLPlayerViewController: JLPlayerProgressViewDelegate {

    func progressView(_ progressView: JLPlayerProgressView, didChanged currentTime: Float64) {
        mediaPlayer.seekPlayerToTime(time: currentTime, completion: { succeed in
            if succeed {
                self.playerControllerEvent  = .playing
                self.updateView(shouldUpdateContent: false)
            } else {
                self.pauseAudio()
                self.updateView(shouldUpdateContent: false)
            }
        })
        

    }

}

extension JLPlayerViewController: SZAVPlayerDelegate {
    
    @objc func handlePlayBtnClick() {
        if playerControllerEvent == .playing {
            pauseAudio()
            updateView(shouldUpdateContent: false)
        } else {
            playAudio()
            updateView(shouldUpdateContent: false)
        }
    }

    @objc func handleNextBtnClick() {
        isPaused = false
        if let currentAudio = currentAudio,
            let audio = findAudio(currentAudio: currentAudio, findNext: true)
        {
            self.currentAudio = audio
            progressView.reset()
            playAudio()
            updateView()
        } else {
            SZLogError("No audio!")
        }

        updateView()
    }

    @objc func handlePreviousBtnClick() {
        isPaused = false
        if let currentAudio = currentAudio,
            let audio = findAudio(currentAudio: currentAudio, findNext: false)
        {
            self.currentAudio = audio
            progressView.reset()
            playAudio()
            updateView(shouldUpdateContent: true)
        } else {
            SZLogError("No audio!")
        }

        updateView()
    }

    private func handlePlayEnd() {
        if let currentAudio = currentAudio,
            let _ = findAudio(currentAudio: currentAudio, findNext: true)
        {
            handleNextBtnClick()
        } else {
            playerControllerEvent = .none
            mediaPlayer.reset()
            updateView()
        }
    }

    private func playAudio() {
        guard let audio = currentAudio else {
            return
        }

        if isPaused {
            isPaused = false
            mediaPlayer.play()
        } else {
            mediaPlayer.pause()
            let config = SZAVPlayerConfig(urlStr: audio.songUrl.absoluteString, uniqueID: nil)
            mediaPlayer.setupPlayer(config: config)
        }
        playerControllerEvent = .playing
    }

    private func pauseAudio() {
        isPaused = true
        mediaPlayer.pause()
        playerControllerEvent = .paused
    }
    
    private func findAudio(currentAudio: JLPlayItem, findNext: Bool) -> JLPlayItem? {
        let playlist = audios
        let audios = findNext ? playlist : playlist.reversed()
        var currentAudioDetected: Bool = false
        for audio in audios {
            if currentAudioDetected {
                return audio
            } else if audio == currentAudio {
                currentAudioDetected = true
            }
        }

        return nil
    }
    


    
    
    func avplayer(_ avplayer: SZAVPlayer, didReceived remoteCommand: SZAVPlayerRemoteCommand) -> Bool {
        return false
    }
    
    func avplayer(_ avplayer: SZAVPlayer, didChanged status: SZAVPlayerStatus) {
        switch status {
        case .readyToPlay:
            SZLogInfo("ready to play")
            if playerControllerEvent == .playing {
                mediaPlayer.play()
            }
        case .playEnd:
            SZLogInfo("play end")
            handlePlayEnd()
        case .loading:
            SZLogInfo("loading")
        case .loadingFailed:
            SZLogInfo("loading failed")
            playAudio()
            updateView(shouldUpdateContent: false)
        case .bufferBegin:
            SZLogInfo("buffer begin")
        case .bufferEnd:
            SZLogInfo("buffer end")
            if playerControllerEvent == .stalled {
                mediaPlayer.play()
            }
        case .playbackStalled:
            SZLogInfo("playback stalled")
            playerControllerEvent = .stalled
        }
        
    }
    
    func avplayer(_ avplayer: SZAVPlayer, refreshed currentTime: Float64, loadedTime: Float64, totalTime: Float64) {
        progressView.update(currentTime: currentTime, totalTime: totalTime)
    }
    
    
    
    
}

    
    

