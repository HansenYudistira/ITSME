import Foundation

protocol URLConstructorProtocol {
    func constructURL(with keyword: String) -> String
}

struct URLConstructor: URLConstructorProtocol {
    func constructURL(with keyword: String) -> String {
        let apiService: APIService = .init()
        var components = URLComponents(string: apiService.baseURL)
        components?.path = "/search"
        let queryItems = [
            URLQueryItem(name: "term", value: keyword),
            URLQueryItem(name: "limit", value: "15"),
            URLQueryItem(name: "entity", value: "musicTrack"),
            URLQueryItem(name: "attribute", value: "songTerm")
        ]
        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? ""
    }
}
