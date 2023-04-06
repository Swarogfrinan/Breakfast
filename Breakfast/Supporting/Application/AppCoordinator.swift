import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let window: UIWindow?
    let rootNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.barTintColor = R.color.backgroundColor()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    let networkTask: NetworkTask
    let repository: Repository
    
    // MARK: - Coordinator

    init(window: UIWindow) {
        self.window = window
        networkTask = NetworkTask()
        repository = Repository(networkTask: networkTask)
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        /// Show List
        let recipeCoordinator = RecipeCoordinator(rootNavigationController: rootNavigationController, repository: repository)
        
        recipeCoordinator.delegate = self
        addChildCoordinator(recipeCoordinator)
        recipeCoordinator.start()
    }
}
