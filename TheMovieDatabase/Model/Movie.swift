import Foundation

struct Movie: Hashable, Decodable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards, poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let boxOffice, production: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case ratings = "Ratings"
        case awards = "Awards"
        case poster = "Poster"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case boxOffice = "BoxOffice"
        case production = "Production"
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.imdbID == rhs.imdbID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}

struct Rating: Codable {
    let source: Source
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }

    enum Source: String, Codable {
        case internetMovieDatabase = "Internet Movie Database"
        case metacritic = "Metacritic"
        case rottenTomatoes = "Rotten Tomatoes"
    }
}
