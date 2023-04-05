import Foundation

struct RecipeDataRaw {
    var recipeID: String
    var name: String
    var imageLinks: [String]
    var lastUpdated: Double
    var description: String?
    var instructions: String
    var difficulty: Int
}
