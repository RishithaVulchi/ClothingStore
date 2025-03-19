import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    var intensity: CGFloat = 1.0

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: blurStyle)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.alpha = intensity
        return effectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
        uiView.alpha = intensity
    }
}


struct SizeSelectionView: View {
    @Binding var selectedSize: String?
    let sizes: [String]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(sizes, id: \.self) { size in
                Text(size)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .foregroundStyle(selectedSize == size ? Color.white : Color.black)
                    .frame(height: 40)
                    .padding(.horizontal, 14)
                    .background(selectedSize == size ? AppColors.primary : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedSize == size ? Color.clear : AppColors.appgray, lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedSize = size
                    }
                    .bold()
            }
        }
    }
}



struct ColorSelectionView: View {
    @Binding var selectedColor: Color?
    @Binding var selectedColorName: String?
    let colors: [(color: Color, name: String)]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(colors, id: \.name) { colorPair in
                ZStack {
                    Circle()
                        .fill(colorPair.color)
                        .frame(width: 30, height: 30)
                    
                    if selectedColor == colorPair.color {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                    }
                }
                .onTapGesture {
                    selectedColor = colorPair.color
                    selectedColorName = colorPair.name
                }
            }
        }
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct ImageGridView: View {
    let thumbnails: [String]

    var body: some View {
        let columns = min(thumbnails.count, 6) // Maximum of 6 images
        let spacing: CGFloat = 8
        let totalSpacing = CGFloat(columns - 1) * spacing
        let imageSize = (UIScreen.main.bounds.width - totalSpacing - 50) / CGFloat(columns) // 50px for safe padding

        VStack {
            HStack(spacing: spacing) {
                ForEach(thumbnails.prefix(columns), id: \.self) { imageUrl in
                    ZStack {
                        // Blurred Background
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                .scaledToFill()
                                .blur(radius: 5)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        // Foreground Image
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(AppColors.appgray, lineWidth: 1))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 10) // Ensures correct horizontal alignment
        }
        .padding(.vertical, 5) // **5px padding at the top & bottom**
        .frame(height: imageSize + 10) // Ensures compact layout without extra spacing
    }
}
