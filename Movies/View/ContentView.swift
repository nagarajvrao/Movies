import SwiftUI

struct ContentView: View {
    var body: some View {
        let networkLayer = Network(session: URLSession.shared, cache: ImageCache.shared)
        let service = MovieService(networkLayer: networkLayer)
        MoviesView(viewModel: MoviesViewModel(service: service))
    }
}

#Preview {
    ContentView()
}
