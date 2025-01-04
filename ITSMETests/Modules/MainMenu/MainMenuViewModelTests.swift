import XCTest
import Combine
@testable import ITSME

final class MockAudioManager: AudioManagerProtocol {
    var playMusicCalled = false
    var stopMusicCalled = false
    var pauseMusicCalled = false
    var errorToThrow: Error?
    
    func playMusic(urlString: String) throws {
        playMusicCalled = true
        if let error = errorToThrow {
            throw error
        }
    }
    
    func stopMusic() {
        stopMusicCalled = true
    }
    
    func pauseMusic() {
        pauseMusicCalled = true
    }
}

final class MockNetworkManager: APIClient {
    let mockData: String = """
    {
     "resultCount":3,
     "results": [
    {"wrapperType":"track", "kind":"song", "artistId":4488522, "collectionId":545398133, "trackId":545398139, "artistName":"P!nk", "collectionName":"The Truth About Love", "trackName":"Just Give Me a Reason (feat. Nate Ruess)", "collectionCensoredName":"The Truth About Love", "trackCensoredName":"Just Give Me a Reason (feat. Nate Ruess)", "artistViewUrl":"https://music.apple.com/us/artist/p-nk/4488522?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/just-give-me-a-reason-feat-nate-ruess/545398133?i=545398139&uo=4", "trackViewUrl":"https://music.apple.com/us/album/just-give-me-a-reason-feat-nate-ruess/545398133?i=545398139&uo=4", 
    "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/57/38/52/573852b0-6b53-4b2e-f8d1-857ec7f60632/mzaf_6157346851900450639.plus.aac.p.m4a", "artworkUrl30":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/2c/b0/de/2cb0de7b-4559-d885-36f8-271c950cba34/886443562097.jpg/30x30bb.jpg", "artworkUrl60":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/2c/b0/de/2cb0de7b-4559-d885-36f8-271c950cba34/886443562097.jpg/60x60bb.jpg", "artworkUrl100":"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/2c/b0/de/2cb0de7b-4559-d885-36f8-271c950cba34/886443562097.jpg/100x100bb.jpg", "collectionPrice":10.99, "trackPrice":1.29, "releaseDate":"2012-09-14T07:00:00Z", "collectionExplicitness":"explicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":15, "trackNumber":4, "trackTimeMillis":242721, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}, 
    {"wrapperType":"track", "kind":"song", "artistId":183313439, "collectionId":858512800, "trackId":858517200, "artistName":"Ed Sheeran", "collectionName":"x (Deluxe Edition)", "trackName":"Thinking Out Loud", "collectionCensoredName":"x (Deluxe Edition)", "trackCensoredName":"Thinking Out Loud", "artistViewUrl":"https://music.apple.com/us/artist/ed-sheeran/183313439?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/thinking-out-loud/858512800?i=858517200&uo=4", "trackViewUrl":"https://music.apple.com/us/album/thinking-out-loud/858512800?i=858517200&uo=4", 
    "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/2f/e3/e1/2fe3e1b7-fa23-7df1-dba1-5b2d2be255f8/mzaf_14267287990353675224.plus.aac.p.m4a", "artworkUrl30":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/a7/7b/92/a77b92fc-d331-dd1b-8772-80597dc51fd0/dj.xllwtvne.jpg/30x30bb.jpg", "artworkUrl60":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/a7/7b/92/a77b92fc-d331-dd1b-8772-80597dc51fd0/dj.xllwtvne.jpg/60x60bb.jpg", "artworkUrl100":"https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/a7/7b/92/a77b92fc-d331-dd1b-8772-80597dc51fd0/dj.xllwtvne.jpg/100x100bb.jpg", "collectionPrice":12.99, "trackPrice":1.29, "releaseDate":"2014-06-20T07:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":16, "trackNumber":11, "trackTimeMillis":281560, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}, 
    {"wrapperType":"track", "kind":"song", "artistId":486597, "collectionId":169003304, "trackId":169004756, "artistName":"Journey", "collectionName":"Greatest Hits (2024 Remaster)", "trackName":"Separate Ways (Worlds Apart) [2024 Remaster]", "collectionCensoredName":"Greatest Hits (2024 Remaster)", "trackCensoredName":"Separate Ways (Worlds Apart) [2024 Remaster]", "artistViewUrl":"https://music.apple.com/us/artist/journey/486597?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/separate-ways-worlds-apart-2024-remaster/169003304?i=169004756&uo=4", "trackViewUrl":"https://music.apple.com/us/album/separate-ways-worlds-apart-2024-remaster/169003304?i=169004756&uo=4", 
    "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/a1/d0/47/a1d04749-621b-c117-3791-f8cc61f1f677/mzaf_10925686221374562657.plus.aac.p.m4a", "artworkUrl30":"https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/71/2d/61/712d617d-f4a4-5904-1b11-d4b4b45c47c5/828768588925.jpg/30x30bb.jpg", "artworkUrl60":"https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/71/2d/61/712d617d-f4a4-5904-1b11-d4b4b45c47c5/828768588925.jpg/60x60bb.jpg", "artworkUrl100":"https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/71/2d/61/712d617d-f4a4-5904-1b11-d4b4b45c47c5/828768588925.jpg/100x100bb.jpg", "collectionPrice":10.99, "trackPrice":1.29, "releaseDate":"1983-01-05T08:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":16, "trackNumber":9, "trackTimeMillis":326230, "country":"USA", "currency":"USD", "primaryGenreName":"Rock", "isStreamable":true}]
    }
    """
    
    enum MockDataError: Error {
        case failedToConvertData
    }
    
    func get(url: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        if let data = mockData.data(using: .utf8) {
            completion(.success(data))
        } else {
            completion(.failure(MockDataError.failedToConvertData))
        }
    }
}

struct MockURLConstructor: URLConstructorProtocol {
    func constructURL(with keyword: String) -> String {
        return "Test"
    }
}

extension MusicModel {
    static func mock() -> MusicModel? {
        let json = """
        {
            "trackId": 1,
            "trackName": "Sample Track",
            "collectionId": 1,
            "collectionName": "Sample Collection",
            "artistId": 1,
            "artistName": "Sample Artist",
            "artworkUrl100": "https://example.com/sample-image.jpg",
            "previewUrl": "https://example.com/sample-preview.mp3"
        }
        """

        let data = json.data(using: .utf8)!

        let decoder = JSONDecoder()
        do {
            let mockMusic = try decoder.decode(MusicModel.self, from: data)
            return mockMusic
        } catch {
            print("Error decoding mock music: \(error)")
            return nil
        }
    }
}

final class MainMenuViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var viewModel: MainMenuViewModel!
    var mockAudioManager: MockAudioManager!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockAudioManager = MockAudioManager()
        let contract = MainMenuViewModelContract(
            networkManager: MockNetworkManager(),
            dataDecoder: DataDecoder(),
            urlConstructor: URLConstructor(),
            audioManager: mockAudioManager
        )

        viewModel = MainMenuViewModel(contract: contract)

    }

    override func tearDown() {
        cancellables = []
        super.tearDown()
    }

    func testSuccessConvertDataToModel() throws {
        let expectation = self.expectation(description: "Fetch data should succeed")
        viewModel.$cachedMusicList
            .sink { musicList in
                guard let musicList else { return }
                XCTAssertEqual(musicList.resultCount, 3)
                XCTAssertEqual(musicList.results.first?.trackName, "Just Give Me a Reason (feat. Nate Ruess)")
                XCTAssertEqual(musicList.results.first?.artistName, "P!nk")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.$musicListViewModel
            .sink { musicList in
                guard let musicList else { return }
                XCTAssertEqual(musicList.count, 3)
                XCTAssertEqual(musicList.first?.trackName, "Just Give Me a Reason (feat. Nate Ruess)")
                XCTAssertEqual(musicList.first?.artistName, "P!nk")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchData(keyword: "Test")
        waitForExpectations(timeout: 2, handler: nil)
        cancellables = []
    }
    
    func testPlayMusicSuccess() {
        let trackId = 1
        guard let mockMusic = MusicModel.mock() else {
            XCTFail("failed to created mock music model")
            return
        }
        viewModel.cachedMusicList = MusicListModel(resultCount: 1, results: [mockMusic])
        viewModel.playAudio(trackId: trackId)
        XCTAssertTrue(mockAudioManager.playMusicCalled)
    }
    
    func testPlayMusicWithInvalidURL() {
        let trackId = 1
        guard let mockMusic = MusicModel.mock() else {
            XCTFail("failed to created mock music model")
            return
        }
        viewModel.cachedMusicList = MusicListModel(resultCount: 1, results: [mockMusic])
        mockAudioManager.errorToThrow = NSError(domain: "Test", code: 1, userInfo: nil)
        viewModel.playAudio(trackId: trackId)
        let expectedMessage = "error in playing the music"
        let actualMessage = viewModel.errorMessage ?? ""
        XCTAssertTrue(
            actualMessage.contains(expectedMessage),
            "Expected error message to contain '\(expectedMessage)', but got \(actualMessage)"
        )
    }
    
    func testStopMusic() {
        viewModel.stopAudio()
        XCTAssertTrue(mockAudioManager.stopMusicCalled)
    }
    
    func testPauseMusic() {
        viewModel.pauseAudio()
        XCTAssertTrue(mockAudioManager.pauseMusicCalled)
    }
}
