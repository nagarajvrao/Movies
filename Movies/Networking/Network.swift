import Foundation
import Combine
import SwiftUI

protocol NetworkProtocol: AnyObject {
    func load<T: Decodable>(url: URL) -> AnyPublisher<T, APIError>
    func fetchImage(url: URL) -> AnyPublisher<UIImage?, APIError>
}

enum APIError: Swift.Error {
    case decodingError
    case urlError
    case fileLoadingFailed
}

final class Network: NetworkProtocol {
    private let session: URLSession
    private let cache: ImageCache

    init(session: URLSession = .shared, cache: ImageCache = .shared) {
        self.session = session
        self.cache = cache
    }

    func load<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
      return session.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .mapError { error -> APIError in
            print(error)
            return error is URLError ? .urlError : .decodingError
        }
        .eraseToAnyPublisher()
    }

    func fetchImage(url: URL) -> AnyPublisher<UIImage?, APIError> {
        if let cachedImage = cache.image(forKey: url) {
            return Just(cachedImage)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage? in
                guard let image = UIImage(data: data) else { return nil }
                self.cache.setImage(image, forKey: url)
                return image
            }
            .mapError { _ in .fileLoadingFailed }
            .eraseToAnyPublisher()
    }
}
