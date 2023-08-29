import Foundation

enum Section {
    case main
}

enum ListItem: Hashable {
    //MARK: This will be the Section, if Expandable Cell is not Required, as in Expandable Cell we assume there is no Sections and treat ListItem as Only Item Cells, and in ListItem Cells we add More Cells
    case header(HeaderItem)
    case value(String)
    case movie(Movie)
}

struct HeaderItem: Hashable {
    let title: Category

    //TODO: Below items should have unique Identifiers (Below item)(Make Same for Movie -> UUID is required as same movie in different Section should also be different, as if same value or Movie found in different Sections, it will consider them same due to Hashing and will crash the App
    let values: [String]?
    let movies: [Movie]?
}

struct item: Hashable {
    let identifier: UUID    //Hash using it
    let value: String
}

enum Category: String, Hashable, CaseIterable {
    case Year
    case Genre
    case Directors
    case Actors
    case AllMovies = "All Movies"

    case Plot
    case Writer
    case ReleaseDate = "Release Date"

}

