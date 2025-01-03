import Combine

internal class MainMenuViewModel {
    private let networkManager: APIClient
    private let decoder: DataDecoderProtocol
    private let urlConstructor: URLConstructorProtocol

    @Published var cachedMusicList: MusicListModel?
    @Published var errorMessage: String?
    private var cancellables: Set<AnyCancellable> = []

    init(contract: MainMenuViewModelContract) {
        self.networkManager = contract.networkManager
        self.decoder = contract.dataDecoder
        self.urlConstructor = contract.urlConstructor
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
                } catch {
                    self.errorMessage = "Error fetching data: \(error)"
                }
            case .failure(let error):
                self.errorMessage = "Error fetching data: \(error)"
            }
        }
    }
}
