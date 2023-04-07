import UIKit

class RecipesViewController: UIViewController {
    
    // MARK: - Views
    let tableView = UITableView()
    let searchController = UISearchController()
    let alertView = ErrorPageView()
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
        filterAndSort()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBar()
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        hideSearchBar(withPlaceholder: searchBar.text)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
        hideSearchBar(withPlaceholder: searchBar.text)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar(withPlaceholder: searchBar.text)
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterAndSort()
    }
    
    // MARK: - SearchBar Helpers
    
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
    private func filterAndSort() {
        filteredRecipes = viewModel.filterRecipesForSearchText(searchText: searchController.searchBar.text, scope: currentSearchCase)
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
    }
}

// MARK: - Actions
@objc
private extension RecipesViewController {
    func sortByButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByName, style: .default) { _ in
            self.currentSortCase = .name
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.sortByDate, style: .default) { _ in
            self.currentSortCase = .date
        })
        actionSheet.addAction(UIAlertAction(title: Constants.ActionSheet.cancel, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
}
// MARK: - Private Methods

private extension RecipesViewController {
    
    func setSearchController() {
        searchController.searchBar.delegate = self
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.SortByButton.title,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(sortByButtonTapped))
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = searchController
    }
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        TableCellViewModel.registerCell(tableView: tableView)
        setViewPosition()
    }
    
    func setViewPosition() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindToViewModel() {
        viewModel.didFinishUpdating = { [weak self] in
            self?.didFinishUpdating()
        }
        viewModel.didReceiveError = { [weak self] error in
            self?.didReceiveError(error)
        }
    }
    
    func didFinishSuccessfully() {
        hideCustomAlert(alertView)
    }
    
    /// In case update was triggered by refreshing the table
    func didFinishUpdating() {
        filteredRecipes = viewModel.filterRecipesForSearchText(
            searchText: searchController.searchBar.text,
            scope: currentSearchCase)
        
        filteredRecipes = viewModel.sortRecipesBy(sortCase: currentSortCase, recipes: filteredRecipes)
        tableView.reloadData()
        hideCustomAlert(alertView)
    }
    
    func didReceiveError(_ error: Error) {
        let title: String
        if let customError = error as? CustomError {
            title = customError.errorTitle
        } else {
            title = Constants.ErrorType.basic
        }
        
        showCustomAlert(alertView,
                        title: title,
                        message: error.localizedDescription,
                        buttonText: Constants.ButtonTitle.refresh)
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



