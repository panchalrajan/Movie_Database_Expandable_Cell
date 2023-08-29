import UIKit

class MovieViewListCell: UICollectionViewListCell {

    var item: Movie?

    override func updateConfiguration(using state: UICellConfigurationState) {

        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration

        var newConfiguration = MovieContentConfiguration().updated(for: state)

        newConfiguration.posterURL = item?.poster
        newConfiguration.title = item?.title
        newConfiguration.language = item?.language
        newConfiguration.year = item?.year

        contentConfiguration = newConfiguration

    }
}
