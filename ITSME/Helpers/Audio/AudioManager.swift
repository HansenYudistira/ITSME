import AVFoundation
import UIKit

internal class AudioManager {
    static let shared = AudioManager()
    private var audioPlayer: AVPlayer?

    private init() {
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

    internal func playMusic(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
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
