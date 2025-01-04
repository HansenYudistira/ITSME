import XCTest
@testable import ITSME

final class AudioManagerTests: XCTestCase {
    func testPlayMusicWithRealURL() {
        let audioManager = AudioManager()
        let validURL = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        let expectation = self.expectation(description: "Audio should play successfully")

        do {
            try audioManager.playMusic(urlString: validURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                expectation.fulfill()
            }
        } catch {
            XCTFail("Failed to play music: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }

    func testPlayMusicWithInvalidURL() {
        let audioManager = AudioManager()
        let invalidURL = "invalid url"
        let expectation = self.expectation(description: "Audio should not play")

        do {
            try audioManager.playMusic(urlString: invalidURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                expectation.fulfill()
            }
        } catch {
            XCTFail("Failed to play music: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }

    func testStopMusic() {
        let audioManager = AudioManager()
        let validURL = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        let expectation = self.expectation(description: "Audio should stop successfully")

        do {
            try audioManager.playMusic(urlString: validURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                audioManager.stopMusic()

                if audioManager.audioPlayer == nil {
                    expectation.fulfill()
                } else {
                    XCTFail("Audio did not stop as expected")
                }
            }
        } catch {
            XCTFail("Failed to play music: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func testPauseMusic() {
        let audioManager = AudioManager()
        let validURL = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        let expectation = self.expectation(description: "Audio should pause successfully")

        do {
            try audioManager.playMusic(urlString: validURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                audioManager.pauseMusic()

                if let player = audioManager.audioPlayer, player.timeControlStatus == .paused {
                    expectation.fulfill()
                } else {
                    XCTFail("Audio did not pause as expected")
                }
            }
        } catch {
            XCTFail("Failed to play music: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }
}
