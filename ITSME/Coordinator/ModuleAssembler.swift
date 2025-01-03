import UIKit

protocol Module {
    associatedtype ViewController: UIViewController
    func assemble(coordinator: Coordinator) -> ViewController
}

internal class ModuleAssembler {
    internal func assemble<T: Module>(
        module: T,
        coordinator: Coordinator
    ) -> T.ViewController {
        return module.assemble(coordinator: coordinator)
    }
}

internal struct MainMenuModule: Module {
    internal func assemble(coordinator: Coordinator) -> MainMenuViewController {
        let networkManager = NetworkManager()
        let vm = MainMenuViewModel(networkManager: networkManager)
        let viewController = MainMenuViewController(viewModel: vm)
        return viewController
    }
}
