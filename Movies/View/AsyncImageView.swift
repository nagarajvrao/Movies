import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader

    init(url: String) {
        _loader = StateObject(wrappedValue: ImageLoader(urlString: url))
    }

    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}
