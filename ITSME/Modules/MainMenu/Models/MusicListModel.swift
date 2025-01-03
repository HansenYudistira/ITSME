struct MusicListModel: Decodable {
    let resultCount: Int
    let results: [TrackModel]
}
