import Foundation
import Combine

protocol MovieServiceProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<PageResponse, APIError>
}

struct MovieService: MovieServiceProtocol {
    private var networkLayer: NetworkProtocol
    
    init(networkLayer: NetworkProtocol) {
        self.networkLayer = networkLayer
    }
    
    func fetchMovies(page: Int) -> AnyPublisher<PageResponse, APIError> {
        guard let path = Bundle.main.path(forResource: "CONTENTLISTINGPAGE-PAGE\(page)", withExtension: "json") else { return Fail(error: .urlError)
            .eraseToAnyPublisher() }
        let url = URL(fileURLWithPath: path)
        return networkLayer.load(url: url)
    }
}
