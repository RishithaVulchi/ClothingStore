import SwiftUI

@MainActor class ProductDetailsViewModel: ObservableObject {
    private let fetchProductUseCase: FetchProductUseCase
    
    @Published var product: ProductDetailsModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedColor: Color?
    @Published var selectedColorName: String?
    @Published var selectedSize: String?
    
    let availableColors: [(color: Color, name: String)] = [
        (AppColors.paleBrown, "Pale Brown"),
        (.brown, "Brown"),
        (AppColors.darkBrown, "Dark Brown"),
        (AppColors.lightBrown, "Light Brown"),
        (.black, "Black")
    ]
    
    let availableSizes: [String] = ["S", "M", "L", "XL", "XXL", "XXXL"]
    
    init(fetchProductUseCase: FetchProductUseCase) {
        self.fetchProductUseCase = fetchProductUseCase
    }
    
    
    @MainActor
    func loadProductDetails(productId: String) async {
        isLoading = true
        do {
            let product = try await fetchProductUseCase.execute(productId: productId)
            self.product = product  // ✅ Ensure this line executes
            self.errorMessage = nil
        } catch {
            self.product = nil
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    
}
