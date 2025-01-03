import UIKit

internal class MainMenuViewController: UIViewController {
    private let viewModel: MainMenuViewModel
    
    init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}
