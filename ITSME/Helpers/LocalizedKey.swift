import UIKit

enum LocalizedKey: String {
    case search
    
    var localized: String {
        let key: String = String(describing: self)
        return NSLocalizedString(key, comment: self.comment)
    }
    
    private var comment: String {
        switch self {
        case .search:
            return "Search bar placeholder"
        }
    }
}
