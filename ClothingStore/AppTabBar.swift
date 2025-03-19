import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @Binding var isTabBarHidden: Bool
    
    enum Tab: CaseIterable {
        case home, shop, favorites, messages, profile
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .shop: return "bag"
            case .favorites: return "heart"
            case .messages: return "message"
            case .profile: return "person"
            }
        }
    }
    
    var body: some View {
        if !isTabBarHidden {
            HStack(spacing: 40) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        ZStack {
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 50, height: 50)
                                    .shadow(radius: 4)
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(selectedTab == tab ? AppColors.primary : AppColors.appgray)
                        }
                    }
                }
            }
            .padding()
            .frame(height: 75)
            .background(Color.black.opacity(0.9))
            .clipShape(Capsule())
            .padding(.horizontal, 20)
        }
    }
}


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: CustomTabBarView.Tab = .home
    @State private var isTabBarHidden = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            TabView(selection: $selectedTab) {
                HomeView(isTabBarHidden: $isTabBarHidden)
                    .tag(CustomTabBarView.Tab.home)
                ShopView()
                    .tag(CustomTabBarView.Tab.shop)
                FavoritesView()
                    .tag(CustomTabBarView.Tab.favorites)
                MessagesView()
                    .tag(CustomTabBarView.Tab.messages)
                ProfileView()
                    .tag(CustomTabBarView.Tab.profile)
            }

            if !isTabBarHidden { 
                CustomTabBarView(selectedTab: $selectedTab, isTabBarHidden: $isTabBarHidden)
                    .padding(.top, 10)
            }
        }
    }
}

// Dummy Views
struct ShopView: View { var body: some View { Text("Shop").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue) }}
struct FavoritesView: View { var body: some View { Text("Favorites").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.green) }}
struct MessagesView: View { var body: some View { Text("Messages").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.purple) }}
struct ProfileView: View { var body: some View { Text("Profile").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.orange) }}
