import UIKit

class MovieDetailsViewController: UIViewController {

    private var movieData: [HeaderItem]!
    private var dataSource: Constants.DataSource<ListItem>!

    private var movie: Movie

    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noThumb")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = movie.title
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadModel()
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.title = movie.title

        view.addSubview(posterView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            posterView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            posterView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 16),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 100),

            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        setupTableView()
        setupDataSource()
    }

    private func loadModel() {
        let vm = MovieDetailViewModel(movie: movie)
        movieData = vm.getHeaderItem()

        vm.updatePoster(urlString: movie.poster) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.posterView.image = image
            }
        }

        updateDataSourceSnapshot()
    }
}

extension MovieDetailsViewController {

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
            case .movie(_):
                return UICollectionViewCell()
            }
        }
    }

    private func updateDataSourceSnapshot() {
        var dataSourceSnapshot = Constants.Snapshot<ListItem>()
        dataSourceSnapshot.appendSections([.main])
        dataSource.apply(dataSourceSnapshot)

        var sectionSnapshot = Constants.HeaderListSection()

        for headerItem in movieData {
            let headerListItem = ListItem.header(headerItem)
            sectionSnapshot.append([headerListItem])

            if let values = headerItem.values {
                let valueListItemArray = values.map { ListItem.value($0) }
                sectionSnapshot.append(valueListItemArray, to: headerListItem)
            }
        }
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
}

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RatingCell.self, forCellReuseIdentifier: RatingCell.reuseIdentifier)

        //Adding Rating Value & Source in UserDefault, then calling if after Reloading Data
        LocalStorage.shared.setInitialValueFromFirstRating(rating: movie.ratings[0])
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RatingCell.reuseIdentifier, for: indexPath) as? RatingCell {
            if let ratingSource = LocalStorage.shared.ratingSource,
               let ratingValue = LocalStorage.shared.ratingValue {
                cell.configure(text: ratingSource, secondaryText: ratingValue)
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Rating"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ratingOptions: [Rating.Source] = []
        for rating in movie.ratings {
            ratingOptions.append(rating.source)
        }

        ActionSheetService.shared.showActionSheet(title: "Select Source", options: ratingOptions) { selectedSource in
            if let selectedRating = self.movie.ratings.first(where: { $0.source == selectedSource }) {
                LocalStorage.shared.ratingSource = selectedRating.source.rawValue
                LocalStorage.shared.ratingValue = selectedRating.value
                tableView.reloadRows(at:[IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }

    }
}
