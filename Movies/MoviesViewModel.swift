import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var service: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    
    init(service: MovieServiceProtocol) {
        self.service = service
        fetchMovies()
    }
    
    func fetchMovies() {
        service.fetchMovies(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }, receiveValue: { [weak self] pageResponse in
                self?.currentPage = (Int(pageResponse.page.pageNum) ?? 0) + 1
                self?.movies.append(contentsOf: pageResponse.page.contentItems.content)
            })
            .store(in: &cancellables)
    }
    
    func loadMoreMoviesIfNeeded() {
        fetchMovies()
    }
}
