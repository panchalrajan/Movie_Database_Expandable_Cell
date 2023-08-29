import UIKit

struct MovieContentConfiguration: UIContentConfiguration, Hashable {
    
    var posterURL: String?
    var title: String?
    var language: String?
    var year: String?

    func makeContentView() -> UIView & UIContentView {
        return  MovieContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {
        return self
    }

}
