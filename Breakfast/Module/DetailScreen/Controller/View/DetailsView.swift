import SnapKit
import UIKit

final class DetailsView: BaseView {
    // MARK: - Views
    
    var recipeCollectionView: UICollectionView
    var recommendationCollectionView: UICollectionView
    
    let pageControl = UIPageControl()
    let recipeNameLabel = DetailsView.makeRecipeNameLabel()
    let timestampLabel = DetailsView.makeTimestampLabel()
    let descriptionTextLabel = DetailsView.makeTextLabel()
    let difficultyTitleLabel = DetailsView.makeTitleLabel()
    let difficultyView = DifficultyView()
    let instructionTitleLabel = DetailsView.makeTitleLabel()
    let instructionTextLabel = DetailsView.makeTextLabel()
    let recommendedTitleLabel = DetailsView.makeTitleLabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - For Action
    
    var didPressSortByButton: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        let layoutRecipeImages = UICollectionViewFlowLayout()
        layoutRecipeImages.scrollDirection = .horizontal
        recipeCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutRecipeImages)
        
        let layoutRecipeRecommendationsImages = UICollectionViewFlowLayout()
        layoutRecipeRecommendationsImages.scrollDirection = .horizontal
        recommendationCollectionView = UICollectionView(frame: CGRect.zero,
                                                        collectionViewLayout: layoutRecipeRecommendationsImages)
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting View
    
    override func setViewAppearance() {
        backgroundColor = R.color.backgroundColor()
        scrollView.showsVerticalScrollIndicator = false
        
        makeRecipeImagesCollection()
        makeRecipeRecommendationsImagesCollection()
    }
    
    override func setViewPosition() {
        addSubview()
        
        setPositionMain()
        setPositionTop()
        setPositionDifficulty()
        setPositionInstruction()
        setPositionRecommendation()
    }
}
// MARK: - Actions

@objc
private extension DetailsView {
    func sortByButtonPressed() {
        didPressSortByButton?()
    }
}

// MARK: - Creating SubViews

private extension DetailsView {

    func makeRecipeImagesCollection() {
        recipeCollectionView.showsHorizontalScrollIndicator = false
        recipeCollectionView.isPagingEnabled = true
        recipeCollectionView.backgroundColor = .white
    }
    
    func makeRecipeRecommendationsImagesCollection() {
        recommendationCollectionView.showsHorizontalScrollIndicator = false
        recommendationCollectionView.backgroundColor = R.color.backgroundColor()
        recommendationCollectionView.contentInset.left = Constants.Inset.classic
        recommendationCollectionView.contentInset.right = Constants.Inset.classic
    }
    
    static func makeTitleLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.big
        label.textColor = R.color.textColorSecondary()

        return label
    }

    static func makeTextLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.thin
        label.textColor = R.color.textColorSecondary()
        label.numberOfLines = .zero

        return label
    }

    static func makeRecipeNameLabel() -> UILabel {
        let label = UILabel()

        label.numberOfLines = Constants.Text.numberOfLinesStandart
        label.font = UIFont.huge
        label.textColor = R.color.textColorSecondary()

        return label
    }

    static func makeTimestampLabel() -> UILabel {
        let label = UILabel()

        label.font = UIFont.thin
        label.textColor = R.color.textColorSecondary()

        return label
    }
}
// MARK: - Set Position

private extension DetailsView {

    func addSubview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [recipeCollectionView,
         pageControl,
         timestampLabel,
         recipeNameLabel,
         descriptionTextLabel,
         difficultyTitleLabel,
         difficultyView,
         instructionTitleLabel,
         instructionTextLabel,
         recommendedTitleLabel,
         recommendationCollectionView].forEach { contentView.addSubview($0) }
    }

    func setPositionMain() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(self)
        }
    }

    func setPositionTop() {
        recipeCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.RecipeImageCollection.height)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(recipeCollectionView.snp.bottom)
            make.centerX.equalTo(recipeCollectionView.snp.centerX)
        }

        timestampLabel.snp.makeConstraints { make in
            make.bottom.equalTo(recipeNameLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        recipeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeCollectionView.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.equalTo(timestampLabel.snp.leading).offset(-Constants.Inset.classic)
        }

        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(recipeNameLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }

    func setPositionDifficulty() {
        difficultyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        difficultyView.snp.makeConstraints { make in
            make.top.equalTo(difficultyTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.equalToSuperview().inset(Constants.Inset.classic)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.Inset.classic)
        }
    }

    func setPositionInstruction() {
        instructionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyView.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        instructionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTitleLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }
    }

    func setPositionRecommendation() {
        recommendedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionTextLabel.snp.bottom).inset(-Constants.Inset.classic)
            make.leading.trailing.equalToSuperview().inset(Constants.Inset.classic)
        }

        recommendationCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendedTitleLabel.snp.bottom)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(Constants.RecommendationImageCollection.height)
        }
    }
}


