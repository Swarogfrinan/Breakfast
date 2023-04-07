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

extension RecipesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        filteredRecipes[indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filteredRecipes[indexPath.row].cellSelected()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Cell.height
    }
}

extension RecipesViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        <#code#>
    }
    private func hideSearchBar(withPlaceholder placeholder : String?) {
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.endEditing(true)
        searchController.isActive = false
    }
    
    private func showSearchBar() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    private func resetSearchBar() {
        searchController.searchBar.text = ""
        filteredRecipes = viewModel.viewModels
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
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



