import UIKit

class MovieContentView: UIView, UIContentView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noThumb")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let languageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var currentConfiguration: MovieContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? MovieContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }


    init(configuration: MovieContentConfiguration) {
        super.init(frame: .zero)

        setupAllViews()
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAllViews() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, languageLabel, yearLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        addSubview(posterView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            posterView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            posterView.widthAnchor.constraint(equalToConstant: 60),
            posterView.heightAnchor.constraint(equalToConstant: 100),
            posterView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    private func apply(configuration: MovieContentConfiguration) {

        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        if let posterURL = configuration.posterURL {
            getImageFromURL(urlString: posterURL) { [weak self] image in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.posterView.image = image

                }
            }
        }
        
        if let title = configuration.title {
            titleLabel.text = title

        }

        if let language = configuration.language {
            languageLabel.text = "Language: " + language

        }
        if let year = configuration.year {
            yearLabel.text = "Year: " + year

        }
    }

    private func getImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageService.shared.getImageFromURL(urlString) { image in
            guard let image = image else {
                return
            }
            completion(image)

        }
    }

}
