import UIKit

class MovieDetailCell: UITableViewCell {

    static let reuseIdentifier = "MovieDetailCellIdentifier"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)


        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),

            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),

        ])
        valueLabel.numberOfLines = 0
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        valueLabel.text = nil
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentWidth = size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: contentWidth * 0.3, height: CGFloat.greatestFiniteMagnitude))
        let valueLabelSize = valueLabel.sizeThatFits(CGSize(width: contentWidth * 0.7, height: CGFloat.greatestFiniteMagnitude))
        let totalHeight = max(titleLabelSize.height, valueLabelSize.height) + 16
        return CGSize(width: size.width, height: totalHeight)
    }
}
