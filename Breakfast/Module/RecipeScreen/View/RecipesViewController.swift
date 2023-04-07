import UIKit

class RecipesViewController: UIViewController {
    
    // MARK: - Views
    let tableView = UITableView()
    let searchController = UISearchController()
    
    // MARK: - Properties
    
    let viewModel: RecipeViewModel
    private var filteredRecipes: [TableCellViewModel] = []
    private var currentSearchCase = SearchCase.all
    
    private var currentSortCase = SortCase.date {
        didSet {
            filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
            tableView.reloadData()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// MARK: - UITableViewDelegate

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRecipes.count
    }
}
// MARK: - Constants

private extension Constants {
    
    struct SortByButton {
        static let title = "Sort by"
    }
    
    struct SearchBar {
        static let placeholder = "Search"
    }
    
    struct BackButton {
        static let text = "Back"
    }
    
    struct ActionSheet {
        static let sortByName = "Sort by Name"
        static let sortByDate = "Sort by Date"
        static let cancel = "Cancel"
    }
    
    struct Cell {
        static let height = CGFloat(180)
    }
}



