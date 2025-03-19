import Foundation

protocol HomeUseCase {
    func fetchHomeData() async throws -> (products: [Product], categories: [ProductCategory])
}

class HomeUseCaseImpl: HomeUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func fetchHomeData() async throws -> (products: [Product], categories: [ProductCategory]) {
        return try await repository.getHomeData()
    }
}
