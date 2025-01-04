internal struct MainMenuViewModelContract {
    internal let networkManager: APIClient
    internal let dataDecoder: DataDecoderProtocol
    internal let urlConstructor: URLConstructorProtocol
}

protocol MainMenuViewModelFetchProtocol {
    func fetchData(keyword: String)
}

protocol MainMenuViewModelAudioProtocol {
    func playAudio(trackId: Int)
    func stopAudio()
    func pauseAudio()
}
