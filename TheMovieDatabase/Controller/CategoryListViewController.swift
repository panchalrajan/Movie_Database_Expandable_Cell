import UIKit

class CategoryListViewController: UIViewController {

    private var collectionViewData: [HeaderItem]!
    private var dataSource: Constants.DataSource<ListItem>!
    private var viewModel: CategoryListViewModel!

    private lazy var searchController = UISearchController()

    private lazy var collectionView: UICollectionView = {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchController()
        loadModel()
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.title = "Movie Database"
        view.addSubview(collectionView)
        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton

        setupDataSource()
    }

    @objc private func filterButtonTapped() {
        var categoryOptions: [Category] = []
        for category in Category.allCases {
            categoryOptions.append(category)
        }

        ActionSheetService.shared.showActionSheet(title: "Select Sorting Category",
                                                  options: categoryOptions) { [weak self] category in
            guard let self = self else {
                return
            }
            let sortedMovies = viewModel.sortedMoviesBasedOn(category: category)
            let sortedMoviesViewController = MoviesListViewController(of: category.rawValue, movies: sortedMovies)
            navigationController?.pushViewController(sortedMoviesViewController, animated: true)
        }
    }
    
    private func loadModel() {
        viewModel = CategoryListViewModel()
        collectionViewData = viewModel.getHeaderItem()
        updateDataSourceSnapshot()
    }
}

extension CategoryListViewController {

    private func setupDataSource() {

        let headerCellRegistration = Constants.ItemCellRegistration<UICollectionViewListCell,HeaderItem> {
            (cell, indexPath, headerItem) in

            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title.rawValue
            cell.contentConfiguration = content

            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }

        let valueCellRegistration = Constants.ItemCellRegistration<UICollectionViewListCell, String> {
            (cell, indexPath, value) in

            var content = cell.defaultContentConfiguration()
            content.text = value
            cell.contentConfiguration = content
        }

        let movieCellRegistration = Constants.ItemCellRegistration<MovieViewListCell,Movie> {
            (cell, indexPath, movie) in
            cell.item = movie
        }

        dataSource = Constants.DataSource<ListItem>(collectionView: collectionView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in

            switch listItem {
            case .header(let headerItem):
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: headerItem)
                return cell

            case .value(let value):
                let cell = collectionView.dequeueConfiguredReusableCell(using: valueCellRegistration,
                                                                        for: indexPath,
                                                                        item: value)
                return cell
            case .movie(let movie):
                let cell = collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration,
                                                                        for: indexPath,
                                                                        item: movie)
                return cell
            }
        }
    }

    private func updateDataSourceSnapshot() {
        var dataSourceSnapshot = Constants.Snapshot<ListItem>()
        dataSourceSnapshot.appendSections([.main])
        dataSource.apply(dataSourceSnapshot)

        var sectionSnapshot = Constants.HeaderListSection()

        for headerItem in collectionViewData {
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])

            if let values = headerItem.values {
                let valueListItemArray = values.map { ListItem.value($0) }
                sectionSnapshot.append(valueListItemArray, to: headerListItem)
            }

            if let movies = headerItem.movies {
                let movieListItemArray = movies.map { ListItem.movie($0) }
                sectionSnapshot.append(movieListItemArray, to: headerListItem)
                sectionSnapshot.expand([headerListItem])
            }
        }
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
}

extension CategoryListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            switch selectedItem {
            case .header(_):
                break
            case .value(let value):
                let filteredMovies = viewModel.filterMoviesBy(value: value)
                let filteredMoviesListViewController = MoviesListViewController(of: value, movies: filteredMovies)
                navigationController?.pushViewController(filteredMoviesListViewController, animated: true)
            case .movie(let movie):
                let movieDetailsViewController = MovieDetailsViewController(movie: movie)
                navigationController?.pushViewController(movieDetailsViewController, animated: true)
            }
        }
    }
}

extension CategoryListViewController: UISearchResultsUpdating {

    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search movies by title, genre, actor, or director"
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased(),
              !searchText.isEmpty else {
            collectionViewData = viewModel.getHeaderItem()
            updateDataSourceSnapshot()
            return
        }
        let filteredMovies = viewModel.filterMoviesBy(value: searchText)
        let headerItem = HeaderItem(title: .AllMovies, values: nil, movies: filteredMovies)
        collectionViewData = [headerItem]
        updateDataSourceSnapshot()
    }
}
