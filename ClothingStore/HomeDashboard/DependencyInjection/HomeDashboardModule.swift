import SwiftUI

class HomeModule {
    @MainActor
    static func provideHomeView(isTabBarHidden: Binding<Bool>) -> HomeView {
        return HomeView(isTabBarHidden: isTabBarHidden)
    }
}
