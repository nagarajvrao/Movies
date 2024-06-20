import Foundation

final class MovieListingMock: URLProtocol {
    static var testURLs = [URL: Data]()
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url, let data = MovieListingMock.dataForURL(url: url) {
            self.client?.urlProtocol(self, didLoad: data)
        }
        if let response = MovieListingMock.response {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = MovieListingMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required but doesn't need to do anything.
    }
    
    static func dataForURL(url: URL) -> Data? {
        if url.absoluteString.contains("page=1") {
            return loadJSONFile(named: "CONTENTLISTINGPAGE-PAGE1")
        } else if url.absoluteString.contains("page=2") {
            return loadJSONFile(named: "CONTENTLISTINGPAGE-PAGE2")
        } else if url.absoluteString.contains("page=3") {
            return loadJSONFile(named: "CONTENTLISTINGPAGE-PAGE3")
        }
        return nil
    }

    static func loadJSONFile(named name: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: filePath))
    }
}
