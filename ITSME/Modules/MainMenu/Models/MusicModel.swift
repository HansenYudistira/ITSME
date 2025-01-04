import Foundation

internal struct MusicModel: Decodable {
    let trackId: Int?
    let trackName: String?
    let collectionId: Int?
    let collectionName: String?
    let artistId: Int?
    let artistName: String?
    let imageURL: String?
    let previewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case trackId, trackName, collectionId, collectionName, artistId, artistName, artworkUrl100, previewUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            trackId = try container.decodeIfPresent(Int.self, forKey: .trackId)
            trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
            collectionId = try container.decodeIfPresent(Int.self, forKey: .collectionId)
            collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName)
            artistId = try container.decodeIfPresent(Int.self, forKey: .artistId)
            artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
            imageURL = try container.decodeIfPresent(String.self, forKey: .artworkUrl100)
            previewUrl = try container.decodeIfPresent(String.self, forKey: .previewUrl)
        } catch {
            print("Error decoding TrackModel: \(error)")
            throw error
        }
    }
}

extension MusicModel {
    func toViewModel() -> MusicViewModel {
        return MusicViewModel(
            trackId: trackId ?? -1,
            trackName: trackName ?? "",
            collectionName: collectionName ?? "",
            artistName: artistName ?? "",
            imageURL: imageURL ?? "")
    }
}
