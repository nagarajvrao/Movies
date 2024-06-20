import Foundation
import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let cache = ImageCache.shared
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        if let cachedImage = cache.image(forKey: URL(string: self.urlString)!) {
            self.image = cachedImage
            return
        }
        
        guard let image = UIImage.getImage(named: urlString) else { return }
        self.cache.setImage(image, forKey: URL(string: self.urlString)!)
        self.image = image
    }
}
