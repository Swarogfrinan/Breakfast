import UIKit

struct DataForDetails {
    var recipeID: String
    var name: String
    var imageLinks: [String]
    var lastUpdated: String
    var description: String
    var instructions: String
    var difficultyLevel: Int
    var similarRecipes: [RecipeBrief]
}
