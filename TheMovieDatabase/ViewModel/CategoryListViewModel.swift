import UIKit

class CategoryListViewModel {

    // To Prevent Reading JSON Multiple Times
    let allMovies: [Movie]

    init() {
        guard let jsonFilePath = Bundle.main.path(forResource: "movies", ofType: "json") else {
            print("JSON file not found.")
            self.allMovies = []
            return
        }
        do {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            let jsonData = try Data(contentsOf: jsonFileURL)
            let decoder = JSONDecoder()
            self.allMovies = try decoder.decode([Movie].self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
            self.allMovies = []
        }
    }

    func getHeaderItem() -> [HeaderItem]? {
        let headerItems: [HeaderItem] = [
            generateHeaderItem(for: .Year, filterBy: \.year, from: allMovies),
            generateHeaderItem(for: .Genre, filterBy: \.genre, from: allMovies),
            generateHeaderItem(for: .Directors, filterBy: \.director, from: allMovies),
            generateHeaderItem(for: .Actors, filterBy: \.actors, from: allMovies),
            generateAllMoviesHeaderItem(from: allMovies)
        ]
        return headerItems
    }

    private func generateHeaderItem<T: CustomStringConvertible>(for title: Category,
                                                        filterBy keyPath: KeyPath<Movie, T>,
                                                        from movies: [Movie]) -> HeaderItem {
        let allValues = movies.compactMap { $0[keyPath: keyPath].description }
        let allItems = allValues.flatMap { $0.split(separator: ",") }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && $0.lowercased() != "n/a" }
        let uniqueItems = Array(Set(allItems)).sorted()
        let headerItem = HeaderItem( title: title, values: uniqueItems, movies: nil)
        return headerItem
    }

    private func generateAllMoviesHeaderItem(from movies: [Movie]) -> HeaderItem {
        let headerItem = HeaderItem(title: .AllMovies, values: nil, movies: movies)
        return headerItem

    }
}

extension CategoryListViewModel {
    func sortedMoviesBasedOn(category: Category) -> [Movie] {
        switch category {
        case .Year:
            return allMovies.sorted(by: { $0.year < $1.year })
        case .Genre:
            return allMovies.sorted(by: { $0.genre < $1.genre })
        case .Directors:
            return allMovies.sorted(by: { $0.director < $1.director })
        case .Actors:
            return allMovies.sorted(by: { $0.actors < $1.actors })
        case .Plot:
            return allMovies.sorted(by: { $0.plot < $1.plot })
        case .Writer:
            return allMovies.sorted(by: { $0.writer < $1.writer })
        case .ReleaseDate:
            return allMovies.sorted(by: { $0.released < $1.released })
        default:
            return allMovies
        }
    }
}

extension CategoryListViewModel {
    func filterMoviesBy(value: String) -> [Movie] {
        return allMovies.filter { movie in
            let lowerCasedSearchText = value.lowercased()
            return movie.title.lowercased().contains(lowerCasedSearchText) ||
            movie.year.lowercased().contains(lowerCasedSearchText) ||
            movie.genre.lowercased().contains(lowerCasedSearchText) ||
            movie.actors.lowercased().contains(lowerCasedSearchText) ||
            movie.language.lowercased().contains(lowerCasedSearchText) ||
            movie.director.lowercased().contains(lowerCasedSearchText)
        }
    }
}
