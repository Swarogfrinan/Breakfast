import SystemConfiguration
import UIKit

final class Repository {
    
    var networkTask: NetworkTask?
    
    // MARK: - Initialization
    
    init(networkTask: NetworkTask) {
        self.networkTask = networkTask
    }
}

// MARK: - Public Methods

extension Repository {
    
    func recipeToRecipeForDetails(_ recipe: Recipe) -> DataForDetails {
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        // description may be not provided or it can be empty
        let description = recipe.description ?? Constants.Description.empty
        
        return DataForDetails(recipeID: recipe.uuid,
                              name: formatText(recipe.name),
                              imageLinks: recipe.images,
                              lastUpdated: date,
                              description: description,
                              instructions: formatText(recipe.instructions),
                              difficultyLevel: recipe.difficulty,
                              similarRecipes: recipe.similar)
        
    }
    
    func recipeListElementToRecipeForCell(_ recipe: RecipeListElement) -> DataForCell {
        return recipeRawToRecipeForCell(recipeListElementToRecipeRaw(recipe))
    }
    
    /// filtering and sorting
    func filterRecipesForSearchText(recipes: [TableCellViewModel],
                                    searchText: String?,
                                    scope: SearchCase? = SearchCase.all) -> [TableCellViewModel] {
        
        guard let safeSearchText = searchText, safeSearchText != "" else {
            return recipes
        }
        
        var mutableRecipes = recipes
        
        switch scope {
        case .name:
            mutableRecipes = recipes.filter { recipe -> Bool in
                recipe.data.name.lowercased().contains(safeSearchText.lowercased())
            }
        case .description:
            mutableRecipes = recipes.filter { recipe -> Bool in
                (recipe.data.description?.lowercased().contains(safeSearchText.lowercased()) ?? false)
            }
        case .instruction:
            mutableRecipes = recipes.filter { recipe -> Bool in
                recipe.data.instructions.lowercased().contains(safeSearchText.lowercased())
            }
        default:
            mutableRecipes = recipes.filter { recipe -> Bool in
                recipe.data.name.lowercased().contains(safeSearchText.lowercased()) ||
                
                (recipe.data.description?.lowercased().contains(safeSearchText.lowercased()) ?? false) ||
                
                recipe.data.instructions.lowercased().contains(safeSearchText.lowercased())
            }
        }
        
        return mutableRecipes
    }
    
    func sortRecipesBy(sortCase: SortCase, recipes: [TableCellViewModel]) -> [TableCellViewModel] {
        var mutableRecipes = recipes
        
        switch sortCase {
        case .name:
            mutableRecipes.sort { first, second in
                return first.data.name < second.data.name
            }
        case .date:
            mutableRecipes.sort { first, second in
                return first.data.date > second.data.date
            }
        }
        
        return mutableRecipes
    }
}

// MARK: - Private Methods

private extension Repository {
    
    func recipeToDetails(_ recipe: Recipe) -> DataForDetails {
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        /// description may be not provided or it can be empty
        let description = recipe.description ?? Constants.Description.empty
        
        return DataForDetails(recipeID: recipe.uuid,
                              name: formatText(recipe.name),
                              imageLinks: recipe.images,
                              lastUpdated: date,
                              description: description,
                              instructions: formatText(recipe.instructions),
                              difficultyLevel: recipe.difficulty,
                              similarRecipes: recipe.similar)
        
    }
    
    func recipeRawToRecipeForCell(_ recipe: RecipeDataRaw) -> DataForCell {
        
        let imageLink = recipe.imageLinks[0]
        let date = getDateForRecipeDetails(lastUpdated: recipe.lastUpdated)
        
        return DataForCell(recipeID: recipe.recipeID,
                           name: recipe.name,
                           imageLink: imageLink,
                           lastUpdated: date,
                           description: recipe.description,
                           instructions: recipe.instructions,
                           date: recipe.lastUpdated)
    }
    
    func recipeListElementToRecipeRaw(_ recipe: RecipeListElement) -> RecipeDataRaw {
        return RecipeDataRaw(recipeID: recipe.uuid,
                             name: formatText(recipe.name),
                             imageLinks: recipe.images,
                             lastUpdated: recipe.lastUpdated,
                             description: formatText(recipe.description),
                             instructions: formatText(recipe.instructions),
                             difficulty: recipe.difficulty)
    }
    
    func formatText(_ text: String?) -> String {
        return text?.replacingOccurrences(of: "<br>", with: "\n") ?? ""
    }
    
    func getDateForRecipeDetails(lastUpdated: Double?) -> String {
        if let safeLastUpdated = lastUpdated {
            let date = Date(timeIntervalSince1970: safeLastUpdated)
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func getDifficultyImage(difficultyLevel: Int) -> UIImage? {
        switch difficultyLevel {
        case 1:
            return R.image.easy()
        case 2:
            return R.image.normal()
        case 3:
            return R.image.hard()
        case 4:
            return R.image.extreme()
        case 5:
            return R.image.insane()
        default:
            return R.image.unknown()
        }
    }
}
