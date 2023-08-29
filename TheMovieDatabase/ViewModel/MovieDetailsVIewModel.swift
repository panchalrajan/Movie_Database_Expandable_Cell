import UIKit

class MovieDetailViewModel {

    private let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    func getHeaderItem() -> [HeaderItem]? {
        let headerItems: [HeaderItem] = [
            generateHeaderItem(title: .Plot, value: movie.plot, splitByComma: false),
            generateHeaderItem(title: .Actors, value: movie.actors, splitByComma: true),
            generateHeaderItem(title: .Directors, value: movie.director, splitByComma: true),
            generateHeaderItem(title: .Writer, value: movie.writer, splitByComma: true),
            generateHeaderItem(title: .Genre, value: movie.genre, splitByComma: true),
            generateHeaderItem(title: .ReleaseDate, value: movie.released, splitByComma: false)

        ]
        return headerItems
    }

    private func generateHeaderItem(title: Category, value: String, splitByComma: Bool) -> HeaderItem {
        var headerItem: HeaderItem
        if splitByComma {
            let allValidItem = value.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.lowercased() != "n/a" }
            let uniqueItems = Array(Set(allValidItem)).sorted()
            headerItem = HeaderItem(title: title, values: uniqueItems, movies: nil)
        } else {
            headerItem = HeaderItem(title: title, values: [value], movies: nil)
        }
        return headerItem
    }
}


extension MovieDetailViewModel {
    func updatePoster(urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageService.shared.getImageFromURL(urlString) { image in
            guard let image = image else {
                return
            }
            completion(image)

        }
    }
}
