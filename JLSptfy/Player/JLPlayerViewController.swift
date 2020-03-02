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
import RxCocoa
import Masonry
import SDWebImage
import SZAVPlayer
import PanModal
import RxDataSources

class JLPlayerViewController: UIViewController {
    

    

    @IBOutlet weak var naLabelContainerView: UIView!
    
    /// 标头label
    private var naLabel:MarqueeLabel = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.configLabel(font: .boldSystemFont(ofSize: 13), textColor: .white, textAlignment: .center, type: .leftRight)
        return label
    }()
    

    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    @IBOutlet weak var titleContainerView: UIView!
    
    private var titleLabel: MarqueeLabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = ""
        label.configLabel(font: .boldSystemFont(ofSize: 24), textColor: .white, textAlignment: .left, type: .leftRight)
        return label
    }()
    
    private var artistLabel: UILabel! = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.text = ""
        label.configLabel(font: .systemFont(ofSize: 16, weight: .medium), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7), textAlignment: .left, type: .leftRight)
        return label
    }()
    

    
    @IBOutlet weak var progressView: JLPlayerProgressView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    private lazy var mediaPlayer = AppDelegate.sharedInstance.mediaPlayer
    
    private var audios:[JLPlayItem] = []
    
    private var currentAudio: JLPlayItem?
    
    private var isPaused: Bool = false
    
    @objc dynamic private var playerControllerEvent: PlayerControllerEventType = .none {
        didSet {
            ListenerCenter.shared.notifyPlayerControllerEventDetected(event: playerControllerEvent)
        }
    }
    
    let data = BehaviorRelay.init(value: [JLPlayItem]())
    
    
    @objc dynamic private var currentIndex: IndexPath = .init(row: 0, section: 0)
    
    
    let dispose = DisposeBag()
    
    
    
    /// 初始化播放器（单曲）
    /// - Parameter item: playitem
    init(item: JLPlayItem) {
        self.currentAudio = item
        self.audios = [item]
        super.init(nibName: "JLPlayerViewController", bundle: nil)
    }
    
    /// 初始化播放器（来自列表）
    /// - Parameter items: items
    init(items: [JLPlayItem],playlistName:String) {
        self.currentAudio = items.first!
        self.audios = items
        self.naLabel.text = playlistName
        super.init(nibName: "JLPlayerViewController", bundle: nil)
    }
    
    
    /// 插播
    /// - Parameter item: item
    public func addToQueue(item: JLPlayItem) {
        self.audios.insert(item, at: 1)
        Observable.just(audios).delay(TimeInterval(0.2), scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty()).drive(self.data).disposed(by: self.dispose)
        
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
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

        
        progressView.delegate = self
        mediaPlayer.delegate = self
        
        setLayout()
        
        updateView()
        
        setupButtonAction()
        
        setupImageCollectionView()
        
        playAudio()
        

    }
    
    private func updateView() {
        guard let audio = currentAudio else {
            return
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
    
    private func setupImageCollectionView() {
        imageCollectionView.delegate = nil
        imageCollectionView.dataSource = nil
        imageCollectionView.register(UINib.init(nibName: "JLPlayerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JLPlayerImageCollectionViewCell")
        
        Observable.just(audios).delay(TimeInterval(0.2), scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty()).drive(self.data).disposed(by: self.dispose)
        
        data.bind(to: self.imageCollectionView.rx.items(cellIdentifier: "JLPlayerImageCollectionViewCell", cellType: JLPlayerImageCollectionViewCell.self)) {index,element,cell in
            cell.item = element
            cell.fetchImage(URL.init(string: element.trackItem.album?.images?.first?.url ?? ""))
            
        }.disposed(by: dispose)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: dispose)
        
        


        
    }
    
    
    
    
    /// 对于旋转m屏幕时，调整cell的尺寸
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: self.imageCollectionView.width, height: self.imageCollectionView.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.imageCollectionView.setCollectionViewLayout(layout, animated: true) { (succeed) in
            self.imageCollectionView.reloadData()
            
        }
        
        
    }
    
    
    private func setLayout() {
        naLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.naLabelContainerView.mas_top)
            make?.bottom.equalTo()(self.naLabelContainerView.mas_bottom)
            make?.leading.equalTo()(self.naLabelContainerView.mas_leading)
            make?.trailing.equalTo()(self.naLabelContainerView.mas_trailing)
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
        
        self.rx.observe(IndexPath.self, "currentIndex").subscribe(onNext: { (index) in
            guard let value = index?.row else {
                return
            }
            if self.audios.count > 1 {
                if value == self.audios.count-1 {
                    self.nextButton.isEnabled = false
                    self.previousButton.isEnabled = true
                } else if value < self.audios.count-1 && value > 0 {
                    self.nextButton.isEnabled = true
                    self.previousButton.isEnabled = true
                } else if value == 0 {
                    self.nextButton.isEnabled = true
                    self.previousButton.isEnabled = false
                }
            } else {
                self.nextButton.isEnabled = false
                self.previousButton.isEnabled = false
            }

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        self.rx.observe(PlayerControllerEventType.self, "playerControllerEvent").subscribe(onNext: { (type) in
            guard let status = type else {
                return
            }
            switch status {
                case .none, .paused ,.failed:
                    self.playButton.setImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
                case .playing, .stalled:
                    self.playButton.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
    
    

}


extension JLPlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let index = collectionView.indexPathsForVisibleItems.first else {
            return
        }
        if currentIndex != index {
            if currentIndex > index {
                print("previous")
                self.currentAudio = self.audios[index.row]
                progressView.reset()
                playAudio()
                updateView()
                
            } else {
                print("next")
                self.currentAudio = self.audios[index.row]
                progressView.reset()
                playAudio()
                updateView()
                
            }
            currentIndex = index
        }
    }
    
}


//MARK: JLPlayerProgressViewDelegate

extension JLPlayerViewController: JLPlayerProgressViewDelegate {

    func progressView(_ progressView: JLPlayerProgressView, didChanged currentTime: Float64) {
        mediaPlayer.seekPlayerToTime(time: currentTime, completion: { succeed in
            if succeed {
                self.playerControllerEvent  = .playing
                
            } else {
                self.pauseAudio()
                
            }
        })

    }
    
    



}

//MARK: Actions

extension JLPlayerViewController {
    
    
    
    @objc func handlePlayBtnClick() {
        if playerControllerEvent == .playing {
            pauseAudio()
        } else {
            playAudio()
            
        }
    }

    @objc func handleNextBtnClick() {
        isPaused = false
        self.imageCollectionView.scrollToItem(at: .init(item: self.currentIndex.row+1, section: 0), at: .right, animated: true)
    }

    @objc func handlePreviousBtnClick() {
        isPaused = false
        self.imageCollectionView.scrollToItem(at: .init(item: self.currentIndex.row-1, section: 0), at: .left, animated: true)
    }

    private func handlePlayEnd() {
        if currentAudio != nil && nextButton.isEnabled
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
            let config = SZAVPlayerConfig(urlStr: audio.wySongUrl.absoluteString, uniqueID: String(audio.wySongId))
            mediaPlayer.setupPlayer(config: config)
        }
        playerControllerEvent = .playing
    }

    private func pauseAudio() {
        isPaused = true
        mediaPlayer.pause()
        playerControllerEvent = .paused
    }
    
//    private func findAudio(currentAudio: JLPlayItem, findNext: Bool) -> JLPlayItem? {
//        let playlist = audios
//        let audios = findNext ? playlist : playlist.reversed()
//        var currentAudioDetected: Bool = false
//        for audio in audios {
//            if currentAudioDetected {
//                return audio
//            } else if audio == currentAudio {
//                currentAudioDetected = true
//            }
//        }
//
//        return nil
//    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

//MARK: SZAVPlayerDelegate

extension JLPlayerViewController: SZAVPlayerDelegate {
    
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
            updateView()
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

extension JLPlayerViewController: PanModalPresentable {
var panScrollable: UIScrollView? {
    return nil
}
var topOffset: CGFloat {
    return 0.0
}

var springDamping: CGFloat {
    return 1.0
}

var transitionDuration: Double {
    return 0.4
}

var transitionAnimationOptions: UIView.AnimationOptions {
    return [.allowUserInteraction, .beginFromCurrentState]
}

var shouldRoundTopCorners: Bool {
    return false
}

var showDragIndicator: Bool {
    return false
}

}
    
    

