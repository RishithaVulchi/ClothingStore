import XCTest
@testable import ClothingStore

class HomeUseCaseTests: XCTestCase {
    var useCase: HomeUseCaseImpl!
    var mockRepository: MockHomeRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockHomeRepository()
        useCase = HomeUseCaseImpl(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testFetchHomeData_Success() async throws {
        let result = try await useCase.fetchHomeData()
        
        XCTAssertEqual(result.products.count, 1)
        XCTAssertEqual(result.products.first?.title, "Test Product")
        XCTAssertEqual(result.categories.count, 1)
        XCTAssertEqual(result.categories.first?.name, "Test Category")
    }

    func testFetchHomeData_Failure() async {
        mockRepository.shouldThrowError = true

        do {
            _ = try await useCase.fetchHomeData()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual((error as NSError).domain, "Test Error")
        }
    }
}
