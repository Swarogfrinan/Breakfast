import Kingfisher
import SnapKit
import UIKit

final class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Self creating
    
    static func registerCell(tableView: UITableView) {
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    static func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> RecipeTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier,
                                                       for: indexPath) as? RecipeTableViewCell
        else {
            return RecipeTableViewCell()
        }
        return cell
    }
    
    // MARK: - Properties
    
    private var viewModel: TableCellViewModel!
    
    var didPressButton: (() -> Void)?
    
    private let recipeImageView = RecipeTableViewCell.makeRecipeImage()
    private let labelsContainer = RecipeTableViewCell.makeLabelsContainer()
    private let titleLabel = RecipeTableViewCell.makeTitleLabel()
    private let descriptionLabel = RecipeTableViewCell.makeDescriptionLabel()
    private let timestampLabel = RecipeTableViewCell.makeTimestampLabel()
    
    private var recipe: DataForCell! {
        didSet {
            titleLabel.text = recipe.name
            descriptionLabel.text = recipe.description
            timestampLabel.text = recipe.lastUpdated
            
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: recipe.imageLink), placeholder: R.image.placeholder())
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension RecipeTableViewCell {
    
    func setupCellData(viewModel: TableCellViewModel) {
        self.viewModel = viewModel
        self.recipe = viewModel.data
        
        viewModel.didUpdate = self.setupCellData
    }
}

// MARK: - Actions

@objc
private extension RecipeTableViewCell {
    
    func buttonPressed() {
        didPressButton?()
    }
}

// MARK: - Creating SubViews

private extension RecipeTableViewCell {
    
    static func makeRecipeImage() -> UIImageView {
        let recipeImageView = UIImageView()
        
        recipeImageView.layer.masksToBounds = true
        recipeImageView.layer.cornerRadius = Constants.Design.cornerRadiusMain
        recipeImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        return recipeImageView
    }
    
    static func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.enormous
        titleLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        titleLabel.textColor = .darkGray
        titleLabel.minimumScaleFactor = Constants.Text.minimumScale
        titleLabel.adjustsFontSizeToFitWidth = true
        
        return titleLabel
    }
    
    static func makeDescriptionLabel() -> UILabel {
        let descriptionLabel = UILabel()
        
        descriptionLabel.font = UIFont.standart
        descriptionLabel.numberOfLines = Constants.Text.numberOfLinesStandart
        descriptionLabel.textColor = .systemGray
        descriptionLabel.minimumScaleFactor = Constants.Text.minimumScale
        
        return descriptionLabel
    }
    
    static func makeTimestampLabel() -> UILabel {
        let timestampLabel = UILabel()
        
        timestampLabel.font = UIFont.standart
        timestampLabel.textColor = .darkGray
        timestampLabel.minimumScaleFactor = Constants.Text.minimumScale
        
        return timestampLabel
    }
    
    static func makeLabelsContainer() -> UIStackView {
        let labelsContainer = UIStackView()
        
        labelsContainer.alignment = .leading
        labelsContainer.axis = .vertical
        labelsContainer.spacing = Constants.LabelsContainer.spacing
        
        return labelsContainer
    }
}

// MARK: - Private Methods

private extension RecipeTableViewCell {
    
    func setViewPosition() {
        [recipeImageView, labelsContainer, timestampLabel].forEach { addSubview($0) }
        [titleLabel, descriptionLabel].forEach { labelsContainer.addArrangedSubview($0) }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().dividedBy(Constants.Image.widthDivision)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(Constants.Inset.small)
            make.trailing.lessThanOrEqualTo(recipeImageView.snp.leading).offset(-Constants.Inset.classic)
        }
        
        labelsContainer.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.top)
            make.bottom.lessThanOrEqualTo(timestampLabel.snp.top).inset(-Constants.LabelsContainer.spacing)
            make.leading.equalToSuperview().inset(Constants.Inset.small)
            make.trailing.equalTo(recipeImageView.snp.leading).offset(-Constants.Inset.classic)
        }
    }
}

// MARK: - Constants

private extension Constants {
    
    static let cellReuseIdentifier = "ListTableViewCell"
    
    struct Image {
        static let widthDivision = CGFloat(2.3)
    }
    
    struct Text {
        static let minimumScale = CGFloat(0.85)
        static let numberOfLinesStandart = 2
    }
    
    struct LabelsContainer {
        static let spacing = CGFloat(7)
    }
}
