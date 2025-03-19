
import XCTest
@testable import ClothingStore
@MainActor
class ProductDetailsViewModelTests: XCTestCase {
    var viewModel: ProductDetailsViewModel!
    var mockUseCase: MockFetchProductUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchProductUseCase()
        viewModel = ProductDetailsViewModel(fetchProductUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func testLoadProductDetails_Success() async {
        let expectedProduct = ProductDetailsModel(
            id: 1, title: "Test Product", price: 99.99,
            description: "A great product", category: "Clothing",
            image: "url", rating: nil
        )
        mockUseCase.result = .success(expectedProduct)

        await viewModel.loadProductDetails(productId: "1")

        XCTAssertNotNil(viewModel.product) // ✅ Ensure product is set
        XCTAssertEqual(viewModel.product?.title, "Test Product") // ✅ Should match expected value
        XCTAssertFalse(viewModel.isLoading) // ✅ Loading should be false
        XCTAssertNil(viewModel.errorMessage) // ✅ No error expected
    }

    func testLoadProductDetails_Failure() async {
        mockUseCase.result = .failure(NSError(domain: "Test Error", code: 500))

        await viewModel.loadProductDetails(productId: "1")

        XCTAssertNil(viewModel.product) // ✅ Should be nil on failure
        XCTAssertFalse(viewModel.isLoading) // ✅ Loading should stop
        XCTAssertNotNil(viewModel.errorMessage) // ✅ Should contain an error message
    }

}

// Mock Use Case
class MockFetchProductUseCase: FetchProductUseCase {
    var result: Result<ProductDetailsModel, Error>?

    func execute(productId: String) async throws -> ProductDetailsModel {
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
