import XCTest
import Combine
@testable import ClothingStore

class MockHomeUseCase: HomeUseCase {
    var shouldThrowError = false
    var mockProducts: [Product] = [Product(id: 1, title: "Test Product", price: 99.99, description: "Test", category: "Test", image: "test.png", rating: Rating(rate: 4.5, count: 10))]
    var mockCategories: [ProductCategory] = [ProductCategory(name: "Test Category")]

    func fetchHomeData() async throws -> (products: [Product], categories: [ProductCategory]) {
        if shouldThrowError {
            throw NSError(domain: "Test Error", code: 500)
        }
        return (mockProducts, mockCategories)
    }
}

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockUseCase: MockHomeUseCase!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockUseCase = MockHomeUseCase()
        viewModel = HomeViewModel(useCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLoadHomeData_Success() {
        let expectation = XCTestExpectation(description: "Fetch home data successfully")

        viewModel.$products
            .dropFirst() // Ignore initial empty state
            .sink { products in
                if !products.isEmpty {
                    XCTAssertEqual(products.first?.title, "Test Product")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadHomeData()
        wait(for: [expectation], timeout: 2.0)
    }

    func testLoadHomeData_Failure() {
        let expectation = XCTestExpectation(description: "Handle API failure")
        mockUseCase.shouldThrowError = true

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (Test Error error 500.)")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadHomeData()
        wait(for: [expectation], timeout: 2.0)
    }
}
