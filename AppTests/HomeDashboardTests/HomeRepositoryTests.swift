import XCTest
@testable import ClothingStore

class MockHomeRepository: HomeRepository {
    var shouldThrowError = false
    var mockProducts: [Product] = [Product(id: 1, title: "Test Product", price: 99.99, description: "Test", category: "Test", image: "test.png", rating: Rating(rate: 4.5, count: 10))]
    var mockCategories: [ProductCategory] = [ProductCategory(name: "Test Category")]

    func getHomeData() async throws -> (products: [Product], categories: [ProductCategory]) {
        if shouldThrowError {
            throw NSError(domain: "Test Error", code: 500)
        }
        return (mockProducts, mockCategories)
    }
}
