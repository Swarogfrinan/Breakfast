import UIKit

protocol ViewModelCoordinatorDelegate: AnyObject {
    func viewWillDisappear()
    func didSelectRecipe(recipeID: String)
}

final class DetailsViewModel {
    // MARK: - Properties
    
    private let repository: Repository
    private let recipeID: String
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
    // MARK: - Initialization
    init(repository: Repository, recipeID: String) {
        self.repository = repository
        self.recipeID = recipeID
    }
}
// MARK: - Public Methods

extension DetailsViewModel {
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func viewWillDisappear() {
        coordinatorDelegate?.viewWillDisappear()
    }
}


