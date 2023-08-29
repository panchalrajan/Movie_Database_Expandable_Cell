import Foundation

class FilteredMovieListViewModel {
    var movies: [Movie]

    init(movies: [Movie]) {
        self.movies = movies
    }

    func createSnapshot() -> Constants.Snapshot<Movie> {
        var snapshot = Constants.Snapshot<Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        return snapshot
    }
}
