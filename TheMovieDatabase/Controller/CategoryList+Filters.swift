import UIKit

extension CategoryListViewController {

    func filterMoviesBasedOn(category: Category) -> [Movie] {
        var filteredMovies: [Movie]  // You need to initialize this array

        // Assuming 'filteredMovies' is an array that contains all the movies you want to filter

        switch category {
        case .Year:
            filteredMovies.sorted(by: {$0.year > $1.year})  // Sort the array in-place
        case .Genre:
            filteredMovies.sorted(by: {$0.genre > $1.genre})
        case .Directors:
            filteredMovies.sorted(by: {$0.director > $1.director})
        case .Actors:
            filteredMovies.sorted(by: {$0.actors > $1.actors})
        case .AllMovies:
            // No need to do anything, just return the array as-is
            break
        case .Plot:
            filteredMovies.sorted(by: {$0.plot > $1.plot})
        case .Writer:
            filteredMovies.sorted(by: {$0.writer > $1.writer})
        case .ReleaseDate:
            filteredMovies.sorted(by: {$0.released > $1.released})
        }

        return filteredMovies  // Return the sorted or unmodified array
    }
}
