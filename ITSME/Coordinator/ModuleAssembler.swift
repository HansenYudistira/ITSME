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
        let contract = MainMenuViewModelContract(
            networkManager: NetworkManager(),
            dataDecoder: DataDecoder(),
            urlConstructor: URLConstructor()
        )
        let vm = MainMenuViewModel(contract: contract)
        let viewController = MainMenuViewController(viewModel: vm)
        return viewController
    }
}
