
import XCTest
@testable import ClothingStore

class FetchProductUseCaseTests: XCTestCase {
    var useCase: FetchProductUseCaseImpl!
    var mockRepository: MockProductDetailsRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductDetailsRepository()
        useCase = FetchProductUseCaseImpl(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchProductDetails_Success() async {
        let expectedProduct = ProductDetailsModel(id: 1, title: "Test Product", price: 99.99, description: "A great product", category: "Clothing", image: "url", rating: nil)
        mockRepository.result = .success(expectedProduct)

        let product = try? await useCase.execute(productId: "1")

        XCTAssertEqual(product?.title, "Test Product")
    }

    func testFetchProductDetails_Failure() async {
        mockRepository.result = .failure(NSError(domain: "Test Error", code: 500))

        do {
            _ = try await useCase.execute(productId: "1")
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

// Mock Repository
class MockProductDetailsRepository: ProductDetailsRepository {
    var result: Result<ProductDetailsModel, Error>?

    func getProductDetails(productId: String) async throws -> ProductDetailsModel {
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
