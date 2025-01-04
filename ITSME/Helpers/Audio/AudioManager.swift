import AVFoundation
import UIKit

protocol AudioManagerProtocol {
    func playMusic(urlString: String) throws
    func stopMusic()
    func pauseMusic()
}

internal class AudioManager: AudioManagerProtocol {
    internal var audioPlayer: AVPlayer?

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
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }

    internal func stopMusic() {
        audioPlayer?.pause()
        audioPlayer = nil
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
