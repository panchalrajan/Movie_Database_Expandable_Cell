import UIKit

class RatingCell: UITableViewCell {

    static let reuseIdentifier = "RatingCellIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        configureDefaultContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, secondaryText: String) {
        var content = defaultContentConfiguration()
        content.text = text
        content.secondaryText = secondaryText
        self.contentConfiguration = content
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureDefaultContent()
    }

    private func configureDefaultContent() {
        var content = defaultContentConfiguration()
        content.text = "Primary Text"
        content.secondaryText = "Secondary Text"
        self.contentConfiguration = content
        accessoryType = .disclosureIndicator
    }
}
