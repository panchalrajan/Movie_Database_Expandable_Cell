import UIKit

final class Constants {
    typealias HeaderListSection = NSDiffableDataSourceSectionSnapshot<ListItem>
    typealias DataSource<ItemType: Hashable> = UICollectionViewDiffableDataSource<Section, ItemType>
    typealias Snapshot<ItemType: Hashable> = NSDiffableDataSourceSnapshot<Section, ItemType>
    typealias ItemCellRegistration<CellType: UICollectionViewCell, ItemType> = UICollectionView.CellRegistration<CellType, ItemType>
}
