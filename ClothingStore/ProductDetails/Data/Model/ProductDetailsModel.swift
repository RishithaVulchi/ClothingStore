import Foundation

// MARK: - Model
struct ProductDetailsModel: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let description, category: String?
    let image: String?
    let rating: Rating?
}

