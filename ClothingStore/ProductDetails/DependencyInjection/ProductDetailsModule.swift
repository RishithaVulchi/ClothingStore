import Foundation
import SwiftUI

// ProductDetailsModule.swift
class ProductDetailsModule {
    @MainActor
    static func provideProductDetailsView(productId: String, isTabBarHidden: Binding<Bool>) -> ProductDetailsView {
        let remoteDataSource = ProductRemoteDataSourceImpl()
        let repository = ProductDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
        let useCase = FetchProductUseCaseImpl(repository: repository)
        let viewModel = ProductDetailsViewModel(fetchProductUseCase: useCase)

        let productIDInt = Int(productId) ?? 0
        return ProductDetailsView(isTabBarHidden: isTabBarHidden, id: productIDInt, viewModel: viewModel)
    }
}
