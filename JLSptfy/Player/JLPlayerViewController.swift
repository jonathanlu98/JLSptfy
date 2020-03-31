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
import MediaPlayer

class JLPlayerViewController: UIViewController {
    

    
    
    @IBOutlet private weak var naLabelContainerView: UIView!
    
    /// 标头label
    private var naLabel:MarqueeLabel = {
        let label = MarqueeLabel.init(frame: .zero, rate: 30, fadeLength: 0).shouldCancelAutoresizing(true)
        label.configLabel(font: .boldSystemFont(ofSize: 13), textColor: .white, textAlignment: .center, type: .leftRight)
        return label
    }()
    

    @IBOutlet private weak var imageCollectionView: UICollectionView!
    
    
    @IBOutlet private weak var titleContainerView: UIView!
    
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

    
    @IBOutlet weak private var progressView: JLPlayerProgressView!
    
    @IBOutlet weak private var playButton: UIButton!
    
    @IBOutlet weak private var previousButton: UIButton!
    
    @IBOutlet weak private var nextButton: UIButton!
    
    
    
    private(set) lazy var mediaPlayer = JLPlayer.shared.mediaPlayer
    
    private(set) var playListName = ""
    
    private(set) var audios:[JLPlayItem] = []
    
    @objc dynamic private(set) var currentAudio: JLPlayItem? = nil
    
    private var isPaused: Bool = false
    
    private(set) var shouldUpdateCollectionView: Bool = false
    
    
    @objc dynamic private(set) var playerControllerEvent: PlayerControllerEventType = .none {
        didSet {
            ListenerCenter.shared.notifyPlayerControllerEventDetected(event: playerControllerEvent)
        }
    }
    
    private let data = BehaviorRelay.init(value: [JLPlayItem]())
    
    
    @objc dynamic private(set) var currentIndex: IndexPath = .init(row: 0, section: 0)
    
    
    private let dispose = DisposeBag()
    
    
    
    /// Returns the default singleton instance.
    @objc public static let shared = JLPlayerViewController.init(nibName: "JLPlayerViewController", bundle: nil)
    
    
    /// 初始化播放器（单曲）
    /// - Parameter item: playitem
    private init(item: JLPlayItem) {
        self.currentAudio = item
        self.audios = [item]
        super.init(nibName: "JLPlayerViewController", bundle: nil)
        
    }
    
    /// 初始化播放器（来自列表）
    /// - Parameter items: items
    private init(items: [JLPlayItem],playListName:String) {
        self.currentAudio = items.first!
        self.audios = items
        self.playListName = playListName
        self.naLabel.text = playListName
        super.init(nibName: "JLPlayerViewController", bundle: nil)

    }
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    /// 插播,不影响当前的播放
    /// - Parameter item: item
    public func addToQueue(item: JLPlayItem) {
        
        self.audios.insert(item, at: 1)
        Observable
            .just(audios)
            .delay(TimeInterval(0), scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.data)
            .disposed(by: self.dispose)

    }
    
    /// 播放单曲，会移出之前的列表
    /// - Parameter item: item
    public func replaceMusic(item: JLPlayItem, from viewController: UIViewController = (AppDelegate.sharedInstance.window?.rootViewController as! JLTabBarController)) {
        self.currentAudio = item
        self.audios = [item]
        self.playListName = ""
        self.currentIndex = .init(row: 0, section: 0)
        self.playerControllerEvent = .none
        
        viewController.present(self, animated: true, completion: nil)
        setupImageCollectionView()
//        Observable
//            .just(audios)
//            .delay(TimeInterval(0), scheduler: MainScheduler.instance)
//            .asDriver(onErrorDriveWith: Driver.empty())
//            .drive(self.data)
//            .disposed(by: self.dispose)
        
        updateView()
        isPaused = false
        playAudio()
        

        
    }
    
    /// 播放列表
    /// - Parameters:
    ///   - items: items
    ///   - playListName: playListName
    public func playList(items: [JLPlayItem],playListName:String, from viewController: UIViewController = (AppDelegate.sharedInstance.window?.rootViewController as! JLTabBarController)) {
        self.currentAudio = items.first
        self.audios = items
        self.playListName = playListName
        self.currentIndex = .init(row: 0, section: 0)
        self.playerControllerEvent = .none
        
        viewController.present(self, animated: true, completion: nil)
        setupImageCollectionView()
        
//        Observable
//            .just(audios)
//            .delay(TimeInterval(0.2), scheduler: MainScheduler.instance)
//            .asDriver(onErrorDriveWith: Driver.empty())
//            .drive(self.data)
//            .disposed(by: self.dispose)
        
        updateView()
        isPaused = false
        playAudio()

    }

    
    
    
    
    override internal var prefersStatusBarHidden: Bool {
        return true
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkView()
    }
    
    public func checkView() {
        
        shouldUpdateCollectionView = true
        self.imageCollectionView.scrollToItem(at: .init(item: self.currentIndex.row, section: 0), at: .centeredHorizontally, animated: true)
        updateView()
        shouldUpdateCollectionView = false
        
    }
    
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        naLabel.text = playListName
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
            cell.imageVIew.fetchImage(URL.init(string: element.trackItem.album?.images?.first?.url ?? "")) { image, succeed in
                self.configNowPlayingCenter()
            }
            
        }.disposed(by: dispose)
        
        imageCollectionView.rx.setDelegate(self).disposed(by: dispose)
        



        
    }
    
    
    
    
    /// 对于旋转屏幕时，调整cell的尺寸
    override internal func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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
            case .none, .paused , .failed, .stalled:
                    self.playButton.setImage(UIImage.init(systemName: "play.circle.fill"), for: .normal)
                case .playing:
                    self.playButton.setImage(UIImage.init(systemName: "pause.circle.fill"), for: .normal)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
    
    

}


extension JLPlayerViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: collectionView.width, height: collectionView.height)
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if !shouldUpdateCollectionView {
            isPaused = false
            
            guard let index = collectionView.indexPathsForVisibleItems.first else {
                return
            }
            if currentIndex != index {
                if currentIndex > index {
                    print("previous")
                    progressView.reset()
                    self.currentAudio = self.audios[index.row]
                    playAudio()
                    updateView()
                    
                } else {
                    print("next")
                    progressView.reset()
                    self.currentAudio = self.audios[index.row]
                    playAudio()
                    updateView()
                    
                }
                currentIndex = index
            }
        }

    }
    
}


//MARK: JLPlayerProgressViewDelegate

extension JLPlayerViewController: JLPlayerProgressViewDelegate {

    internal func progressView(_ progressView: JLPlayerProgressView, didChanged currentTime: Float64) {
        mediaPlayer.seekPlayerToTime(time: currentTime, completion: { succeed in
            if succeed {
                self.playerControllerEvent  = .playing
                self.configNowPlayingCenter()
                
            } else {
                self.playerControllerEvent = .paused
                self.pauseAudio()
            }
        })

    }
    
    



}

//MARK: Actions

extension JLPlayerViewController {
    
    
    @objc private func handlePlayBtnClick() {
        if playerControllerEvent == .playing {
            pauseAudio()
        } else {
            playAudio()
            
        }
    }

    @objc private func handleNextBtnClick() {
        isPaused = false
        self.imageCollectionView.scrollToItem(at: .init(item: self.currentIndex.row+1, section: 0), at: .right, animated: true)
        
    }

    @objc private func handlePreviousBtnClick() {
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
        
        self.configNowPlayingCenter()
        
        
    }

    private func pauseAudio() {
        isPaused = true
        mediaPlayer.pause()
        
        playerControllerEvent = .paused
        
        self.configNowPlayingCenter()
        
        
    }
    

    
    @IBAction private func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

//MARK: SZAVPlayerDelegate

extension JLPlayerViewController: SZAVPlayerDelegate {
    
    internal func avplayer(_ avplayer: SZAVPlayer, didReceived remoteCommand: SZAVPlayerRemoteCommand) -> Bool {
        
        switch remoteCommand {
            
        case .play:
            JLPlayer.shared.viewController.playAudio()
        case .pause:
            JLPlayer.shared.viewController.pauseAudio()
        case .next:
            if currentIndex.row >= 0 && currentIndex.row < audios.count-1 {
                currentIndex.row += 1
                isPaused = false
                progressView.reset()
                currentAudio = audios[currentIndex.row]
                
                playAudio()
                updateView()
            }

        case .previous:
            if currentIndex.row > 0 && currentIndex.row <= audios.count-1 {
                currentIndex.row -= 1
                isPaused = false
                progressView.reset()
                currentAudio = audios[currentIndex.row]
                
                playAudio()
                updateView()
            }
        }
        
        return true
    }
    
    internal func avplayer(_ avplayer: SZAVPlayer, didChanged status: SZAVPlayerStatus) {
        switch status {
        case .readyToPlay:
            SZLogInfo("ready to play")

            playerControllerEvent = .playing
            isPaused = false
            mediaPlayer.play()
            configNowPlayingCenter()

        case .playEnd:
            SZLogInfo("play end")
            
            playerControllerEvent = .paused
            handlePlayEnd()
            
        case .loading:
            SZLogInfo("loading")
            
            playerControllerEvent = .playing
            
        case .loadingFailed:
            SZLogInfo("loading failed")
            
            self.playerControllerEvent = .failed
            avplayer.pause()
            
        case .bufferBegin:
            SZLogInfo("buffer begin")
            
        case .bufferEnd:
            SZLogInfo("buffer end")
            
//            playerControllerEvent = .playing
//            isPaused = false
//            mediaPlayer.play()
//            configNowPlayingCenter()

        case .playbackStalled:
            SZLogInfo("playback stalled")
            
            playerControllerEvent = .stalled
            
        }
        

    }
    
    internal func avplayer(_ avplayer: SZAVPlayer, refreshed currentTime: Float64, loadedTime: Float64, totalTime: Float64) {
        
        
        if playerControllerEvent == .playing {
            progressView.update(currentTime: currentTime, totalTime: totalTime)
        }

        
    }
    
    
    
    
}


//MARK: configNowPlayingCenter

extension JLPlayerViewController {

    
    func configNowPlayingCenter() {

        print("config")
        
        if let imageUrl = currentAudio?.trackItem.album?.images?.first?.url {
            SDWebImageManager.shared.loadImage(with: URL.init(string: imageUrl), options: .retryFailed, progress: nil) { (image, _, _, _, _, _) in
                
                if (image != nil) {
                    self.mediaPlayer.setupNowPlaying(title: self.currentAudio?.trackItem.name ?? "JLSptfy", description: self.currentAudio?.trackItem.artists?.first?.name ?? "", image: image ?? UIImage())
                }

            }
        }

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
    
    

