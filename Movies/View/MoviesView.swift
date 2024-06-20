import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel: MoviesViewModel

    init(viewModel: MoviesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    let itemsPerRow = 3

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer().frame(height: 80) // Space for the custom navigation bar

                        let itemWidth = (UIScreen.main.bounds.width - 30 * CGFloat(itemsPerRow + 1)) / CGFloat(itemsPerRow)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30),  count: itemsPerRow), spacing: 90) {
                            ForEach(viewModel.movies) { movie in
                                MovieItemView(movie: movie, itemWidth: itemWidth)
                                    .frame(width: itemWidth)
                                    .onAppear {
                                        if movie == viewModel.movies.last {
                                            viewModel.loadMoreMoviesIfNeeded()
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true) // Hide the default navigation bar

                // Custom Navigation Bar with solid background
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                // Action for back button
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                            }
                            Text("Romantic Comedy")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                // Action for search button
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, geometry.safeAreaInsets.top)
                        .padding(.bottom, 16)
                        .background(Color.black)
                        .shadow(radius: 5)
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.top)
                }
                .zIndex(1)
            }
        }
    }
}

struct MovieItemView: View {
    let movie: Movie
    let itemWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
             AsyncImageView(url: movie.posterImage.removingExtension)
                .frame(width: itemWidth, height: itemWidth * 1.5) // Adjust height proportionally
                .clipped()

            Text(movie.name)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .light))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
    }
}
