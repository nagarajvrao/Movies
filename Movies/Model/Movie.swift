import Foundation

struct PageResponse: Codable {
    let page: Page
}

// MARK: - Page
struct Page: Codable {
    let title, totalContentItems, pageNum, pageSize: String
    let contentItems: ContentItems

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

// MARK: - ContentItems
struct ContentItems: Codable {
    let content: [Movie]
}

// MARK: - Content
struct Movie: Codable, Identifiable {
    let id = UUID()
    let name: String
    let posterImage: String

    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie)-> Bool {
        lhs.id == rhs.id
    }
}
