import UIKit

protocol DetailsDelegate: Coordinator {
    
    func didFinish(from coordinator: DetailsCoordinator)
}

final class DetailsCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let rootNavigationController: UINavigationController
    let repository: Repository
    let recipeID: String
    
    weak var delegate: DetailsDelegate?
    
    // MARK: - Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository, recipeID: String) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
        self.recipeID = recipeID
    }
    
    override func start() {
        let viewModel = DetailsViewModel(repository: repository, recipeID: recipeID)
        viewModel.coordinatorDelegate = self
        
        let viewController = DetailsViewController(viewModel: viewModel)
        
        rootNavigationController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }
}

// MARK: - ViewModel Delegate

extension DetailsCoordinator: ViewModelCoordinatorDelegate {
    func viewWillDisappear() {
        rootNavigationController.navigationBar.prefersLargeTitles = true
        self.finish()
    }
    
    func didSelectRecipe(recipeID: String) {
        let detailsCoordinator = DetailsCoordinator(rootNavigationController: rootNavigationController,
                                                    repository: repository,
                                                    recipeID: recipeID)
        
        detailsCoordinator.delegate = self.delegate
        self.delegate?.addChildCoordinator(detailsCoordinator)
        rootNavigationController.navigationBar.prefersLargeTitles = false
        detailsCoordinator.start()
    }
}
