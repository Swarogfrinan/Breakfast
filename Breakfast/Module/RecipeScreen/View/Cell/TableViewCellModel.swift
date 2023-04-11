import UIKit

final class TableCellViewModel {
    
    // MARK: - Properties
    
    let data: DataForCell
    
    // MARK: - Actions
    
    var didReceiveError: ((Error) -> Void)?
    var didUpdate: ((TableCellViewModel) -> Void)?
    var didSelectRecipe: ((String) -> Void)?
    
    // MARK: - Initialization
    
    init(recipe: DataForCell) {
        self.data = recipe
    }
    
}

// MARK: - CellRepresentable Protocol

extension TableCellViewModel: TableViewCellRepresentable {
    
    static func registerCell(tableView: UITableView) {
        RecipeTableViewCell.registerCell(tableView: tableView)
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = RecipeTableViewCell.dequeueCell(tableView: tableView, indexPath: indexPath)
        cell.setupCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectRecipe?(data.recipeID)
    }
    
}
