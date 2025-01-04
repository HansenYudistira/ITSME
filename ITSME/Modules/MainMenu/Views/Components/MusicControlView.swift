import UIKit

internal class MusicControlView: UIView {
    enum ButtonType: String {
        case playPause = "Play/Pause"
        case previous = "Previous"
        case next = "Next"
    }
    lazy var pausePlayButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .secondarySystemBackground
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        button.tintColor = .black
        button.accessibilityLabel = ButtonType.playPause.rawValue
        return button
    }()
    lazy var prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.end.alt.fill"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = ButtonType.previous.rawValue
        return button
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.end.alt.fill"), for: .normal)
        button.tintColor = .black
        button.accessibilityLabel = ButtonType.next.rawValue
        return button
    }()
    lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.isContinuous = true
        return slider
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 5
        layer.masksToBounds = false

        let buttonStackView = UIStackView(arrangedSubviews: [prevButton, pausePlayButton, nextButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        let vStackView = UIStackView(arrangedSubviews: [buttonStackView, sliderView])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 8
        addSubview(vStackView)
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32)
        ])
    }
}
