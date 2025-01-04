import XCTest
@testable import ITSME

final class URLConstructorTests: XCTestCase {
    func testConstructKeywordstoURL() throws {
        let keyword = "test"
        let urlConstructor = URLConstructor()
        let url = urlConstructor.constructURL(with: keyword)
        XCTAssertEqual(
            url,
            "https://itunes.apple.com/search?term=test&limit=15&entity=musicTrack&attribute=songTerm"
        )
    }
}
