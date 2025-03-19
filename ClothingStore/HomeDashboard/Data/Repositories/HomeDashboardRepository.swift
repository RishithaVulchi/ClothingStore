import Foundation

protocol HomeRemoteDataSource {
    func fetchHomeDataFromAPI() async throws -> (products: [Product], categories: [ProductCategory])
}

class HomeRemoteDataSourceImpl: HomeRemoteDataSource {
    func fetchHomeDataFromAPI() async throws -> (products: [Product], categories: [ProductCategory]) {
        guard let productUrl = URL(string: "\(AppConstants.baseURL)products"),
              let categoryUrl = URL(string: "\(AppConstants.baseURL)products/categories") else {
            throw NSError(domain: "Invalid URL", code: 400)
        }
        
        async let products: [Product] = NetworkService.shared.fetchData(from: productUrl)
        async let categoryNames: [String] = NetworkService.shared.fetchData(from: categoryUrl)

        // Await both API calls concurrently for better performance
        return try await (products, categoryNames.map { ProductCategory(name: $0) })
    }
}

protocol HomeRepository {
    func getHomeData() async throws -> (products: [Product], categories: [ProductCategory])
}
class HomeRepositoryImpl: HomeRepository {
    private let remoteDataSource: HomeRemoteDataSource
    
    init(remoteDataSource: HomeRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getHomeData() async throws -> (products: [Product], categories: [ProductCategory]) {
        return try await remoteDataSource.fetchHomeDataFromAPI()
    }
}
