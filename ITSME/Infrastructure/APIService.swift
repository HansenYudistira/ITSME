struct APIService {
    let baseURL: String = "https://itunes.apple.com/search?term="
    var method: HTTPMethod = .GET
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}
