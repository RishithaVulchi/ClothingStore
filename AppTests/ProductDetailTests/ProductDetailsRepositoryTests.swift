
import XCTest
@testable import ClothingStore

class ProductDetailsRepositoryTests: XCTestCase {
    var repository: ProductDetailsRepositoryImpl!
    var mockRemoteDataSource: MockProductRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockProductRemoteDataSource()
        repository = ProductDetailsRepositoryImpl(remoteDataSource: mockRemoteDataSource)
    }

    override func tearDown() {
        repository = nil
        mockRemoteDataSource = nil
        super.tearDown()
    }

    func testGetProductDetails_Success() async {
        let expectedProduct = ProductDetailsModel(id: 1, title: "Test Product", price: 99.99, description: "A great product", category: "Clothing", image: "url", rating: nil)
        mockRemoteDataSource.result = .success(expectedProduct)

        let product = try? await repository.getProductDetails(productId: "1")

        XCTAssertEqual(product?.title, "Test Product")
    }

    func testGetProductDetails_Failure() async {
        mockRemoteDataSource.result = .failure(NSError(domain: "Test Error", code: 500))

        do {
            _ = try await repository.getProductDetails(productId: "1")
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

// Mock Remote Data Source
class MockProductRemoteDataSource: ProductRemoteDataSource {
    var result: Result<ProductDetailsModel, Error>?

    func fetchProductDetailsFromAPI(productId: String) async throws -> ProductDetailsModel {
        if let result = result {
            switch result {
            case .success(let product):
                return product
            case .failure(let error):
                throw error
            }
        }
        throw NSError(domain: "Unexpected Error", code: -1)
    }
}
