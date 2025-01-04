import UIKit

internal class ControlStackView: UIStackView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        axis = .horizontal
        spacing = 8
    }
}
