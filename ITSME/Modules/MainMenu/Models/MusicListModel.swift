internal struct MusicListModel: Decodable {
    let resultCount: Int
    let results: [MusicModel]
}
