import Foundation
import SwiftUI

extension UIImage {
    static func getImage(named: String) -> UIImage? {
        let placeholder = "placeholder_for_missing_posters"
        
        func fetchImage(named: String) -> UIImage? {
            if let filePath = Bundle.main.path(forResource: named, withExtension: "jpg") {
                do {
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let image = UIImage(data: data) else { return nil }
                    return image
                }
            }
            return nil
        }
        return fetchImage(named: named) ?? fetchImage(named: placeholder)
    }
    var image: Image {
        Image(uiImage: self)
    }
}
