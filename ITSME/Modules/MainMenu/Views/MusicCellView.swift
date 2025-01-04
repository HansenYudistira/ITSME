import UIKit

internal class MusicCellView: UITableViewCell {
    static let identifier: String = "MusicCell"
    lazy var songName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(songName)
        setupConstraints()
    }
    
    private func setupConstraints() {
        songName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            songName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            songName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            songName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            songName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    internal func configure(with model: MusicViewModel) {
        songName.text = model.trackName
    }
}
