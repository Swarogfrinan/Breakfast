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
// MARK: - Private Methods

private extension DetailsViewModel {
    
    func viewModelForMain(imageLink: String) -> ImageCollectionViewCellViewModel {
        ImageCollectionViewCellViewModel(imageLink: imageLink)
    }
    
    func viewModelForRecommended(name: String, imageLink: String, uuid: String) -> RecommendedImageCollectionViewCellViewModel {
        let viewModel = RecommendedImageCollectionViewCellViewModel(name: name, imageLink: imageLink, uuid: uuid)
        viewModel.didSelectRecommendedRecipe = { [weak self] recipeID in
            self?.coordinatorDelegate?.didSelectRecipe(recipeID: recipeID)
        }
        return viewModel
    }
    
    func getDataFromNetwork() {
        repository.networkTask?.getRecipe(uuid: recipeID) { [weak self] response in
            
            switch response {
            case .success(let recipeContainer):
                self?.recipe = self?.repository.recipeToRecipeForDetails(recipeContainer.recipe)
                self?.didFinishUpdating?()
                
            case .failure(let error):
                self?.didReceiveError?(error)
            }
        }
    }
}



