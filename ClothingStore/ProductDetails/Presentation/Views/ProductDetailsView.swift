import Foundation
import SwiftUI

struct ProductDetailsView: View {
    @Binding var isTabBarHidden: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var favoriteProducts: [Int: Bool] = [:]
    let id: Int
    @StateObject var viewModel : ProductDetailsViewModel
    @State private var thumbnails: [String] = [AppConstants.sampleThumbNailOne, AppConstants.sampleThumbNailTwo, AppConstants.sampleThumbNailThree,  AppConstants.sampleThumbNailFour, AppConstants.sampleThumbNailFive, AppConstants.sampleThumbNailSix]
    @State private var showMore = false
    @State private var isTruncated = false
    @State private var truncatedText = ""
    let maxLines = 2
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let product = viewModel.product {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Main Image with Blur & Buttons
                        ZStack(alignment: .top) {
                            
                            AsyncImage(url: URL(string: product.image ?? "")) { image in
                                image.resizable()
                                    .blur(radius: 20)
                                    .opacity(0.5)
                                    .clipped()
                            } placeholder: {
                                Image("PlaceholderImg")
                            }
                            .frame(height: 430)
                            .clipped()
                            
                        
                            
                            AsyncImage(url: URL(string: product.image ?? "")) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 430)
                            .clipped()
                            
                            VStack {
                                HStack {
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image(systemName: "arrow.backward")
                                            .foregroundColor(.black)
                                            .padding(8)
                                            .frame(width: 30, height: 30)
                                            .background(Color.white.opacity(0.6))
                                            .clipShape(Circle())
                                    }
                                    Spacer()
                                    Text("Product Details")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Color.black)
                                    Spacer()
                                    FavoriteButton(isFavorite: Binding(
                                        get: { $favoriteProducts.wrappedValue[product.id ?? 0, default: false] },
                                        set: { newValue in $favoriteProducts.wrappedValue[product.id ?? 0] = newValue }
                                    ))
                                }
                                .padding(.horizontal, 30)
                                .padding(.top, 0)
                                
                                ImageGridView(thumbnails: thumbnails)
                                    .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10)))
                                    .padding(.horizontal, 25)
                                    .padding(.top, 285)
                                    .padding(.bottom, 15)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Product Title
                        HStack {
                            Text(product.title ?? "No Title")
                                .font(.system(size: 14, weight: .regular)).foregroundStyle( Color.gray)
                                .lineLimit(1)
                            Spacer()
                            
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(AppColors.appStarColor)
                                Text(String(format: "%.1f", product.rating?.rate ?? 0.2))
                                    .font(.system(size: 14, weight: .regular)).foregroundStyle( Color.gray)
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Text("Styling")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading, spacing: 5) {
                                    Text("Product Details")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Color.black)
                                        .padding(.horizontal, 30)

                                    ZStack(alignment: .bottomTrailing) {
                                        HStack(alignment: .lastTextBaseline, spacing: 4) {
                                            Text(product.description ?? "")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                                .lineLimit(showMore ? nil : maxLines)
                                                .background(
                                                    Text(product.description ?? "")
                                                        .lineLimit(nil)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .hidden()
                                                        .background(GeometryReader { geo in
                                                            Color.clear.onAppear {
                                                                let textHeight = geo.size.height
                                                                DispatchQueue.main.async {
                                                                    isTruncated = textHeight > UIFont.systemFont(ofSize: 14).lineHeight * CGFloat(maxLines)
                                                                }
                                                            }
                                                        })
                                                )

                                            if isTruncated && !showMore {
                                                Button(action: { showMore.toggle() }) {
                                                    Text(" Read More")
                                                        .font(.system(size: 14, weight: .regular))
                                                        .foregroundColor(AppColors.primary)
                                                        .underline()
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 30)
                                    }

                                    if showMore {
                                        Button(action: { showMore.toggle() }) {
                                            Text("Read Less")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(AppColors.primary)
                                                .underline()
                                        }
                                        .padding(.horizontal, 30)
                                    }
                                }
                        
                        Divider()
                        .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading) {
                            Text("Select Size")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.black)
                            ScrollView(.horizontal) {
                                SizeSelectionView(
                                    selectedSize: $viewModel.selectedSize,
                                    sizes: viewModel.availableSizes
                                )
                            }
                            .scrollIndicators(.hidden)
                        }
                        .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Select Color:")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.black)
                                Text(viewModel.selectedColorName ?? " ")
                                    .font(.headline)
                                    .foregroundColor( Color.gray)
                            }
                            ColorSelectionView(
                                selectedColor: $viewModel.selectedColor,
                                selectedColorName: $viewModel.selectedColorName,
                                colors: viewModel.availableColors
                            )
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                    }

                    
                }
                // Bottom Price & Add to Cart
                VStack {
                    HStack {
                        VStack(spacing: 6) {
                            Text("Total Price")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.secondary)
                            Text("$\(product.price ?? 0, specifier: "%.2f")")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "bag.fill")
                                    .foregroundColor(.white)
                                Text("Add to Cart")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 250, height: 50)
                            .background(Color.brown)
                            .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 13)
                }
                .padding(.bottom, 10)
                .background(Color.white)
                .clipShape(RoundedCorner(corners: [.topLeft, .topRight]))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5) // Shadow only at the top
                .onDisappear {
                    thumbnails.removeAll()
                    showMore = false
                    isTruncated = false
                    isTabBarHidden = false
                }
            } else {
                Text("Failed to load product")
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            isTabBarHidden = true
            Task {
                await viewModel.loadProductDetails(productId: String(id))
            }
        }
    }
}
