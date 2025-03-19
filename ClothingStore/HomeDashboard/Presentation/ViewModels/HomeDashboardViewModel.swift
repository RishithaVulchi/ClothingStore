import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [ProductCategory] = []
    @Published var errorMessage: String?
    
    private let useCase: HomeUseCase
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func loadHomeData() {
        Task {
            do {
                let data = try await useCase.fetchHomeData()
                DispatchQueue.main.async {
                    self.products = data.products
                    self.categories = data.categories
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

