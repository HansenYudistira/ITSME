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
}

extension MainMenuViewModel: MainMenuViewModelFetchProtocol {
    func fetchData(keyword: String) {
        let keywordQuery = keyword.replacingOccurrences(of: " ", with: "+")
        let url: String = urlConstructor.constructURL(with: keywordQuery)
        networkManager.get(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
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
            case .failure(let error):
                self.errorMessage = "Error fetching data: \(error)"
            }
        }
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
