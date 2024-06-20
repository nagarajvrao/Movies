import Foundation
import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    private init() { }

    func image(forKey key: URL) -> UIImage? {
        return cache.object(forKey: key as NSURL) ?? loadImageFromDisk(key: key)
    }

    func setImage(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
        saveImageToDisk(image: image, key: key)
    }

    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    private func saveImageToDisk(image: UIImage, key: URL) {
        let fileURL = cacheDirectory().appendingPathComponent(key.lastPathComponent)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }

    private func loadImageFromDisk(key: URL) -> UIImage? {
        let fileURL = cacheDirectory().appendingPathComponent(key.lastPathComponent)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}
