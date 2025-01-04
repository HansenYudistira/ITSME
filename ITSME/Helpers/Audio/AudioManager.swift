import AVFoundation
import UIKit

protocol AudioManagerProtocol {
    func playMusic(urlString: String) throws
    func stopMusic()
    func pauseMusic()
}

internal class AudioManager: AudioManagerProtocol {
    internal var audioPlayer: AVPlayer?
    internal var playerItem: AVPlayerItem?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    internal func playMusic(urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }

    @objc private func playerDidFinishPlaying() {
        audioPlayer?.seek(to: .zero)
        audioPlayer?.play()
    }

    internal func stopMusic() {
        audioPlayer?.pause()
        if let item = playerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
        }
        audioPlayer?.replaceCurrentItem(with: nil)
        audioPlayer = nil
        playerItem = nil
    }

    internal func pauseMusic() {
        guard let player = audioPlayer else {
            return
        }
        player.pause()
    }

    @objc private func handleAppDidEnterBackground() {
        pauseMusic()
    }

    @objc private func handleAppDidBecomeActive() {
        if let player = audioPlayer, player.timeControlStatus == .paused {
            player.play()
        }
    }

    deinit {
        stopMusic()
        NotificationCenter.default.removeObserver(self)
    }
}
