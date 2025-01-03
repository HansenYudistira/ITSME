internal struct MainMenuViewModelContract {
    let networkManager: APIClient
    let dataDecoder: DataDecoderProtocol
    let urlConstructor: URLConstructorProtocol
}

protocol MainMenuViewModelFetchProtocol {
    func fetchData(keyword: String)
}
