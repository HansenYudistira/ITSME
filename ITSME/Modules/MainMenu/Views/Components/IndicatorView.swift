import UIKit

internal class IndicatorView: UIView {
    private var bars: [UIView] = []
    private var barAnimations: [UIViewPropertyAnimator] = []
    internal var isPlaying: Bool = false

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .systemBackground
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])

        for _ in 0..<30 {
            let bar = UIView()
            bar.backgroundColor = .systemGray
            bar.layer.cornerRadius = 1
            bar.isHidden = true
            bars.append(bar)
            stackView.addArrangedSubview(bar)
        }
    }

    func start() {
        if isPlaying { return }
        isPlaying = true
        for bar in bars {
            bar.isHidden = false
            animateBar(bar: bar)
        }
    }

    func stop() {
        if !isPlaying { return }
        isPlaying = false
        for animation in barAnimations {
            animation.stopAnimation(true)
        }
        bars.forEach { $0.isHidden = true }
    }

    private func animateBar(bar: UIView) {
        let initialHeight = CGFloat.random(in: 0...10)
        let duration = CGFloat.random(in: 2...5)
        bar.bounds.size.height = initialHeight
        let targetHeight: CGFloat = 50
        let animation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            bar.bounds.size.height = targetHeight
        }

        barAnimations.append(animation)

        animation.addCompletion { [weak self] _ in
            bar.bounds.size.height = initialHeight
            self?.animateBar(bar: bar)
        }

        animation.startAnimation()
    }
}
