import Kingfisher
import SnapKit
import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let recipeImageView = RecommendedCollectionViewCell.makeRecipeImage()
    private let titleLabel = RecommendedCollectionViewCell.makeTitleLabel()
    
// MARK: - Properties
    
    var didPressButton: (() -> Void)?
    
    private var imageLink: String? {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink ?? ""), placeholder: R.image.placeholder())
        }
    }
    
    private var viewModel: RecommendedImageCollectionViewCellViewModel!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Self creating

extension RecommendedCollectionViewCell {
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
    }
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> RecommendedCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier,
                                                            for: indexPath) as? RecommendedCollectionViewCell else {
            return RecommendedCollectionViewCell()
        }
        
        return cell
    }
}

