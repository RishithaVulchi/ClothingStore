import Foundation

protocol FetchProductUseCase {
    func execute(productId: String) async throws -> ProductDetailsModel
}

class FetchProductUseCaseImpl: FetchProductUseCase {
    private let repository: ProductDetailsRepository

    init(repository: ProductDetailsRepository) {
        self.repository = repository
    }

    func execute(productId: String) async throws -> ProductDetailsModel {
        return try await repository.getProductDetails(productId: productId) // ✅ Corrected method call
    }
}
