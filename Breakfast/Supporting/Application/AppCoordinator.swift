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
    
    // MARK: - Coordinator
    
    init(window: UIWindow) {
        self.window = window
        networkTask = NetworkTask()
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        /// Show List
        let recipeController = RecipesController(rootNavigationController: rootNavigationController)
        
        recipeController.delegate = self
        addChildCoordinator(recipeController)
        recipeController.start()
    }
}
