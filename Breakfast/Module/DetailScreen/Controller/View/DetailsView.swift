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
}
// MARK: - For Action

var didPressSortByButton: (() -> Void)?

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

