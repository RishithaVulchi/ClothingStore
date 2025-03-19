import SwiftUI

extension Image {
    func asUIImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: 500))
        return renderer.image { context in
            let view = UIHostingController(rootView: self).view
            view?.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}
