import Combine

internal class MainMenuViewModel {
    private let networkManager: APIClient
    private let decoder: DataDecoderProtocol
    private let urlConstructor: URLConstructorProtocol
    private let audioManager: AudioManagerProtocol

    @Published var cachedMusicList: MusicListModel?
    @Published var musicListViewModel: [MusicViewModel]?
    @Published var errorMessage: String?
    private var cancellables: Set<AnyCancellable> = []

    init(contract: MainMenuViewModelContract) {
        self.networkManager = contract.networkManager
        self.decoder = contract.dataDecoder
        self.urlConstructor = contract.urlConstructor
        self.audioManager = contract.audioManager
    }
    
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
}

extension MainMenuViewModel: MainMenuViewModelFetchProtocol {
    func fetchData(keyword: String) {
        if let data = mockData.data(using: .utf8) {
            do {
                self.cachedMusicList = try self.decoder.decode(MusicListModel.self, from: data)
                guard let musicList = self.cachedMusicList?.results else { return }
                var cachedMusicViewModel: [MusicViewModel] = []
                for music in musicList {
                    cachedMusicViewModel.append(music.toViewModel())
                }
                self.musicListViewModel = cachedMusicViewModel
            } catch {
                self.errorMessage = "Error fetching data: \(error)"
            }
        }
//        let keywordQuery = keyword.replacingOccurrences(of: " ", with: "+")
//        let url: String = urlConstructor.constructURL(with: keywordQuery)
//        networkManager.get(url: url) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let data):
//                do {
//                    self.cachedMusicList = try self.decoder.decode(MusicListModel.self, from: data)
//                    guard let musicList = self.cachedMusicList?.results else { return }
//                    var cachedMusicViewModel: [MusicViewModel] = []
//                    for music in musicList {
//                        cachedMusicViewModel.append(music.toViewModel())
//                    }
//                    self.musicListViewModel = cachedMusicViewModel
//                } catch {
//                    self.errorMessage = "Error fetching data: \(error)"
//                }
//            case .failure(let error):
//                self.errorMessage = "Error fetching data: \(error)"
//            }
//        }
    }
}

extension MainMenuViewModel: MainMenuViewModelAudioProtocol {
    func playAudio(trackId: Int) {
        guard
            let index = cachedMusicList?.results.firstIndex(where: {
                $0.trackId == trackId
            }),
            let url = cachedMusicList?.results[index].previewUrl
        else {
            return
        }
        do {
            try audioManager.playMusic(urlString: url)
        } catch {
            self.errorMessage = "error in playing the music \(error.localizedDescription)"
        }
    }

    func stopAudio() {
        audioManager.stopMusic()
    }

    func pauseAudio() {
        audioManager.pauseMusic()
    }
}
