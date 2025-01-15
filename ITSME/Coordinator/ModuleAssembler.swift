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
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: configuration)
        let contract = MainMenuViewModelContract(
            networkManager: NetworkManager(urlSession: session),
            dataDecoder: DataDecoder(),
            urlConstructor: URLConstructor(),
            audioManager: AudioManager()
        )
        let vm = MainMenuViewModel(contract: contract)
        let viewController = MainMenuViewController(viewModel: vm)
        return viewController
    }
}
