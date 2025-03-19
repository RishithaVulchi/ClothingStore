import SwiftUI

struct LocationPickerView: View {
    @Binding var selectedLocation: String
    let locations = ["New York, USA", "Los Angeles, USA", "Chicago, USA", "San Francisco, USA"]
    
    var body: some View {
        NavigationView {
            List(locations, id: \.self) { location in
                Button(action: {
                    selectedLocation = location
                }) {
                    HStack {
                        Text(location)
                        if selectedLocation == location {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Location")
            .navigationBarItems(trailing: Button("Done") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

struct CarouselView: View {
    @State private var currentIndex = 0
    let images = ["BannerImage", "BannerImage", "BannerImage"]
    
    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    ZStack(alignment: .bottomLeading) {
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .cornerRadius(12)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Collection")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Text("Discount 50% for\nthe first transaction")
                                .font(.system(size: 12, weight: .light))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                print("Shop Now tapped")
                            }) {
                                Text("Shop Now")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .frame(height: 28)
                                    .background(AppColors.primary)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.clear.opacity(0.6))
                                .blur(radius: 5)
                        )
                        .padding(.leading, 16)
                        .padding(.bottom, 12)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 140)
            
            // Custom Page Indicator
            HStack(spacing: 6) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .frame(width: currentIndex == index ? 10 : 8, height: 8)
                        .foregroundColor(currentIndex == index ? AppColors.primary : AppColors.appgray)
                }
            }
        }
        .onAppear {
            UIPageControl.appearance().isHidden = true
        }
    }
}


@ViewBuilder
func timeBlock(_ value: String) -> some View {
    Text(value)
        .font(.system(size: 14))
        .foregroundColor(AppColors.primary)
        .frame(width: 24, height: 24)
        .background(AppColors.secondary)
        .cornerRadius(5)
}

@ViewBuilder
func separator() -> some View {
    Text(":")
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(AppColors.primary)
}


struct FilterBarView: View {
    @Binding var selectedFilter: String
    let filters = ["All", "Newest", "Popular", "Man", "Women", "More"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        Text(filter)
                            .font(.system(size: 14))
                            .foregroundColor(selectedFilter == filter ? .white : .black)
                            .frame(height: 36)
                            .padding(.horizontal, 15)
                            .background(selectedFilter == filter ? AppColors.primary : Color.clear)
                            .cornerRadius(17)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(selectedFilter == filter ? Color.clear : AppColors.appgray, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}


struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 30, height: 30)
            
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .black)
                .font(.system(size: 16))
        }
        .padding(.trailing, 10)
        .padding(.top, 10)
        .onTapGesture {
            isFavorite.toggle()
        }
    }
}


@ViewBuilder
func productCard(for product: Product, favoriteProducts: Binding<[Int: Bool]>) -> some View {
    VStack(alignment: .leading, spacing: 5) {
        ZStack {
            // Blurred background image
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 120)
                    .blur(radius: 10)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 150, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            }
            .allowsHitTesting(false) // Prevents interactions with the blurred image

            // Clear foreground image
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            } placeholder: {
                Image("PlaceholderImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            }
            .contentShape(Rectangle()) // Ensures interactions work as expected

            // Favorite button overlay
            .overlay(alignment: .topTrailing) {
                FavoriteButton(isFavorite: Binding(
                    get: { favoriteProducts.wrappedValue[product.id, default: false] },
                    set: { newValue in favoriteProducts.wrappedValue[product.id] = newValue }
                ))
            }
        }
        
        HStack {
            Text(product.title)
                .font(.system(size: 14).weight(.regular))
                .lineLimit(1)
            
            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .foregroundColor(AppColors.appStarColor)
                    .font(.system(size: 10))
                Text("\(product.rating.rate, specifier: "%.1f")")
                    .font(.system(size: 12).weight(.thin))
            }
        }
        
        HStack {
            Text(product.formattedPrice)
                .font(.system(size: 14).weight(.medium))
            Spacer()
        }
    }
    .frame(width: 150)
    .padding(10)
    .background(Color.white)
    .cornerRadius(10)
}
