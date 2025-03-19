import Foundation

// MARK: - Remote Data Source Interface
protocol ProductRemoteDataSource {
    func fetchProductDetailsFromAPI(productId: String) async throws -> ProductDetailsModel
}

// MARK: - Remote Data Source Implementation
class ProductRemoteDataSourceImpl: ProductRemoteDataSource {
    func fetchProductDetailsFromAPI(productId: String) async throws -> ProductDetailsModel {
        guard let productUrl = URL(string: "\(AppConstants.baseURL)products/\(productId)") else {
            throw NSError(domain: "Invalid URL", code: 400)
        }
        
        return try await NetworkService.shared.fetchData(from: productUrl)
    }
}

// MARK: - Repository Interface
protocol ProductDetailsRepository {
    func getProductDetails(productId: String) async throws -> ProductDetailsModel
}

// MARK: - Repository Implementation
class ProductDetailsRepositoryImpl: ProductDetailsRepository {
    private let remoteDataSource: ProductRemoteDataSource
    
    init(remoteDataSource: ProductRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getProductDetails(productId: String) async throws -> ProductDetailsModel {
        return try await remoteDataSource.fetchProductDetailsFromAPI(productId: productId)
    }
}
