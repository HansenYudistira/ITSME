import UIKit

internal class IndicatorView: UIView {
    private var bars: [UIView] = []
    private var barAnimations: [UIViewPropertyAnimator] = []
    internal var isAnimating: Bool = false

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
        stackView.spacing = 4
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

        for _ in 0..<10 {
            let bar = UIView()
            bar.backgroundColor = .systemBlue
            bar.layer.cornerRadius = 2
            bar.isHidden = true
            bars.append(bar)
            stackView.addArrangedSubview(bar)
        }
    }

    func start() {
        if isAnimating { return }
        isAnimating = true
        for (index, bar) in bars.enumerated() {
            bar.isHidden = false
            animateBar(bar: bar, index: index)
        }
    }

    func stop() {
        if !isAnimating { return }
        isAnimating = false
        for animation in barAnimations {
            animation.stopAnimation(true)
        }
        bars.forEach { $0.isHidden = true }
    }

    private func animateBar(bar: UIView, index: Int) {
        let initialHeight = CGFloat.random(in: 0...10)
        bar.bounds.size.height = initialHeight
        let targetHeight: CGFloat = 50
        let animation = UIViewPropertyAnimator(duration: 1 + Double(index) * 0.2, curve: .easeInOut) {
            bar.bounds.size.height = targetHeight
        }

        barAnimations.append(animation)

        animation.addCompletion { [weak self] _ in
            bar.bounds.size.height = initialHeight
            self?.animateBar(bar: bar, index: index)
        }

        animation.startAnimation()
    }
}
