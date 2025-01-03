import UIKit

enum Destination {
    case mainMenu
}

protocol Coordinator {
    func start()
    func navigate(to destination: Destination)
}

internal class AppCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private let moduleAssembler: ModuleAssembler
    
    init(
        navigationController: UINavigationController,
        moduleAssembler: ModuleAssembler = ModuleAssembler()
    ) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }
    
    internal func start() {
        navigate(to: .mainMenu)
    }
    
    internal func navigate(to destination: Destination) {
        switch destination {
        case .mainMenu:
            let mainMenuModule = MainMenuModule()
            let vc = moduleAssembler.assemble(module: mainMenuModule, coordinator: self)
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
