import UIKit
import Kingfisher

internal class MusicCellView: UITableViewCell {
    static let identifier: String = "MusicCell"
    lazy var songName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    lazy var artistName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    lazy var collectionName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    lazy var indicatorView: IndicatorView = IndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let textStackView = UIStackView(arrangedSubviews: [songName, artistName, collectionName])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        let mainStackView = UIStackView(arrangedSubviews: [cellImageView, textStackView, indicatorView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.distribution = .fillProportionally
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImageView.widthAnchor.constraint(equalTo: cellImageView.heightAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 100),
            indicatorView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    internal func configure(with model: MusicViewModel) {
        songName.text = model.trackName
        artistName.text = model.artistName
        collectionName.text = model.collectionName
        if let url = URL(string: model.imageURL) {
            self.cellImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [.cacheOriginalImage]
            )
        }
    }
}
