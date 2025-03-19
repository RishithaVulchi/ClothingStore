import SwiftUI

struct HomeView: View {
    @Binding var isTabBarHidden: Bool
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedLocation: String = "New York, USA"
    @State private var showLocationPicker = false
    @State private var hasNotification = true
    @State private var searchText = ""
    @State private var selectedFilter: String = "All"
    @State private var favoriteProducts: [Int: Bool] = [:]
    @State private var selectedProductID: Int?
    @State private var isShowingProductDetails = false
    
    init(isTabBarHidden: Binding<Bool>) {
            let remoteDataSource = HomeRemoteDataSourceImpl()
            let repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource)
            let useCase = HomeUseCaseImpl(repository: repository)
            
            _viewModel = StateObject(wrappedValue: HomeViewModel(useCase: useCase))
            self._isTabBarHidden = isTabBarHidden
        }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            // Location
                            HStack {
                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Location")
                                        .font(.system(size: 12).weight(.thin))
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text(selectedLocation)
                                            .font(.system(size: 14).weight(.regular))
                                            .foregroundColor(.black)
                                        
                                        Button(action: {
                                            showLocationPicker.toggle()
                                        }) {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Button(action: {
                                        print("Bell icon tapped")
                                        hasNotification = false
                                    }) {
                                        Image(systemName: "bell.fill")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(.black)
                                            .padding(10)
                                            .background(AppColors.appgray)
                                            .clipShape(Circle())
                                    }
                                    
                                    if hasNotification {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 6, height: 6)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                            .offset(x: 6, y: -6)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            .sheet(isPresented: $showLocationPicker) {
                                LocationPickerView(selectedLocation: $selectedLocation)
                            }
                            
                            // Search Bar
                            HStack {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(AppColors.primary)
                                    
                                    TextField("Search", text: $searchText)
                                        .font(.system(size: 14).weight(.regular))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(AppColors.appgray, lineWidth: 1)
                                )
                                
                                Button(action: {
                                    print("Filter button tapped")
                                }) {
                                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                            
                            // Banner View
                            CarouselView()
                                .padding(.horizontal, 20)
                                .padding(.bottom, 13)
                            
                            // Categories List
                            HStack {
                                Text("Category")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Button(action: {
                                    print("See All tapped")
                                }) {
                                    Text("See All")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 13) {
                                    ForEach(viewModel.categories, id: \.name) { category in
                                        VStack(spacing: 8) {
                                            Image(systemName: category.icon)
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .padding()
                                                .background(AppColors.secondary)
                                                .foregroundStyle(AppColors.primary)
                                                .clipShape(Circle())
                                            Text(category.name.capitalized)
                                                .font(.caption)
                                                .frame(width: 80)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                            
                            // Flash Sale Section
                            HStack {
                                Text("Flash Sale")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                HStack(spacing: 3) {
                                    Text("Closing in: ")
                                        .font(.system(size: 12).weight(.thin))
                                        .foregroundColor(.black)
                                    
                                    timeBlock("20") // Hours
                                    separator()
                                    timeBlock("20") // Minutes
                                    separator()
                                    timeBlock("20") // Seconds
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Filter Buttons
                            HStack {
                                FilterBarView(selectedFilter: $selectedFilter)
                                    .padding(.top, 8)
                            }
                            
                            // Product Grid with Navigation
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(viewModel.products, id: \.id) { product in
                                    Button(action: {
                                        selectedProductID = product.id
                                    }) {
                                        productCard(for: product, favoriteProducts: $favoriteProducts)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 10)
                            .onChange(of: selectedProductID) { oldValue, newValue in
                                if let productId = newValue {
                                    print("Navigating to Product ID: \(productId)")
                                    isShowingProductDetails = true
                                }
                            }
                            
                            
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
                
                .navigationDestination(isPresented: $isShowingProductDetails) {
                    if let productId = selectedProductID {
                        ProductDetailsModule.provideProductDetailsView(productId: "\(productId)", isTabBarHidden: $isTabBarHidden)
                    }
                }
            }


        }

        .onAppear { viewModel.loadHomeData() }
    }
}
