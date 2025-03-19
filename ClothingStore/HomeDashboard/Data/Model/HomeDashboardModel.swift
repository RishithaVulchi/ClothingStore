import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
}

struct Rating: Codable , Hashable {
    let rate: Double
    let count: Int
}

struct ProductCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String

    var icon: String {
        switch name.lowercased() {
        case "electronics": return "laptopcomputer"
        case "jewelery": return "sparkles"
        case "men's clothing": return "tshirt"
        case "women's clothing": return "person.fill"
        default: return "questionmark.circle"
        }
    }
}
enum Home {
    struct Request {}
    
    struct Response {
        let products: [Product]
        let categories: [ProductCategory]
    }
    
    struct ViewModel {
        let products: [Product]
        let categories: [ProductCategory]
    }
}
