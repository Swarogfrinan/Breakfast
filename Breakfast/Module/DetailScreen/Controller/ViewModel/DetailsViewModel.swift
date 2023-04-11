import UIKit

protocol ViewModelCoordinatorDelegate: AnyObject {
    func viewWillDisappear()
    func didSelectRecipe(recipeID: String)
}

final class DetailsViewModel {
    // MARK: - Properties
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
    
}
