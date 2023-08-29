import UIKit

class MoviesListViewController: UIViewController {

    private var viewModel: FilteredMovieListViewModel

    private var dataSource: Constants.DataSource<Movie>!
    private var snapshot: Constants.Snapshot<Movie>!
    private var movies: [Movie]
    private var filteredByValue: String

    private lazy var collectionView: UICollectionView = {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()


    init(of value: String, movies: [Movie]) {
        self.viewModel = FilteredMovieListViewModel(movies: movies)
        self.movies = movies
        self.filteredByValue = value
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filteredByValue + " Movies"
        self.view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        let movieCellRegistration = Constants.ItemCellRegistration<MovieViewListCell, Movie> { (cell, indexPath, movie) in
            cell.item = movie
        }

        dataSource = Constants.DataSource<Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Movie) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: movieCellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)

            return cell
        }

        let snapshot = viewModel.createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: false)

    }
}

extension MoviesListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedItem = dataSource.itemIdentifier(for: indexPath) {
            let movieDetailsViewController = MovieDetailsViewController(movie: selectedItem)
            navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}
