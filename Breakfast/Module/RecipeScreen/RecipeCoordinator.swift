import UIKit

final class RecipeCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let rootNavigationController: UINavigationController
    let repository: Repository
    
    weak var delegate: AppCoordinator?
    
    // MARK: - Coordinator
    
    init(rootNavigationController: UINavigationController, repository: Repository) {
        self.rootNavigationController = rootNavigationController
        self.repository = repository
    }
    
    override func start() {
        
        let recipeViewModel = RecipeViewModel(repository: repository)
        recipeViewModel.coordinatorDelegate = self
        
        let recipeViewController = RecipesViewController(viewModel: recipeViewModel)
        recipeViewController.title = Constants.NavigationBarTitle.recipes
        
        rootNavigationController.setViewControllers([recipeViewController], animated: false)
    }
    
}

// MARK: - ViewModel Delegate

extension RecipeCoordinator: RecipeViewModelCoordinatorDelegate {
    
    /// switches Scene to Recipe Details
    func didSelectRecipe(recipeID: String) {
        let detailsCoordinator = DetailsCoordinator(rootNavigationController: rootNavigationController,
                                                    repository: repository,
                                                    recipeID: recipeID)
        
        detailsCoordinator.delegate = self
        addChildCoordinator(detailsCoordinator)
        rootNavigationController.navigationBar.prefersLargeTitles = false
        detailsCoordinator.start()
    }
    
}

// MARK: - Coordinator Delegate

extension RecipeCoordinator: DetailsDelegate {
    func didFinish(from coordinator: DetailsCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
