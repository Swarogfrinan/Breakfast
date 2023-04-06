import UIKit

protocol RecipeViewModelCoordinatorDelegate: AnyObject {
    func didSelectRecipe(recipeID: String)
}

final class RecipeViewModel {
    
    // MARK: - Properties
    
    var viewModels: [TableCellViewModel] = []
    
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    private let repository: Repository
    
    // MARK: - Initialization
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var didReceiveError: ((Error) -> Void)?
    var didStartUpdating: (() -> Void)?
    var didFinishUpdating: (() -> Void)?
}

// MARK: - Public Methods

extension RecipeViewModel {
    
    func reloadData() {
        self.didStartUpdating?()
        getDataFromNetwork()
    }
    
    func filterRecipesForSearchText(searchText: String?, scope: SearchCase?) -> [TableCellViewModel] {
        repository.filterRecipesForSearchText(recipes: viewModels, searchText: searchText, scope: scope)
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [TableCellViewModel]) -> [TableCellViewModel] {
        repository.sortRecipesBy(sortCase: sortCase, recipes: recipes)
    }
}

// MARK: - Private Methods

private extension RecipeViewModel {
    
    func viewModelFor(_ recipe: DataForCell) -> TableCellViewModel {
        let viewModel = TableCellViewModel(recipe: recipe)
        
        viewModel.didSelectRecipe = { [weak self] recipeID in
            self?.coordinatorDelegate?.didSelectRecipe(recipeID: recipeID)
        }
        
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError?(error)
        }
        
        return viewModel
    }
    
    func getDataFromNetwork() {
        repository.networkTask?.getAllRecipes { response in
            
            switch response {
            case .success(let recipesContainer):
                
                self.viewModels = recipesContainer.recipes.compactMap {
                    let recipe = self.repository.recipeListElementToRecipeForCell($0)
                    return self.viewModelFor(recipe)
                }
                
                self.didFinishUpdating?()
                
            case .failure(let error):
                self.didReceiveError?(error)
            }
        }
    }
}
