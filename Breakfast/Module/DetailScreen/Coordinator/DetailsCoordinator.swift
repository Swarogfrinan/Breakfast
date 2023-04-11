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


