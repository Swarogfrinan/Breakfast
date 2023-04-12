import Kingfisher
import SnapKit
import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views
    
    private let recipeImageView = UIImageView()
    // MARK: - Internal Properties
    
    private var viewModel: ImageCollectionViewCellViewModel!
    
    private var imageLink: String! {
        didSet {
            recipeImageView.kf.indicatorType = .activity
            recipeImageView.kf.setImage(with: URL(string: imageLink), placeholder: R.image.placeholder())
        }
    }

// MARK: - Initialization

override init(frame: CGRect) {
    super.init(frame: frame)
    setViewPosition()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
}
// MARK: - Self creating

extension DetailsCollectionViewCell {
    
    static func registerCell(collectionView: UICollectionView) {
        collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellReuseIdentifier)
    }
    
    static func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> DetailsCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier,
                                                            for: indexPath) as? DetailsCollectionViewCell else {
            return DetailsCollectionViewCell()
        }
        return cell
    }
}
// MARK: - Public Methods

extension DetailsCollectionViewCell {
    
    func setCellData(viewModel: ImageCollectionViewCellViewModel) {
        self.viewModel = viewModel
        imageLink = viewModel.data
        
        viewModel.didUpdate = self.setCellData
    }
}
// MARK: - Private Methods

private extension DetailsCollectionViewCell {
    
    func setViewPosition() {
        addSubview(recipeImageView)
        recipeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - Constants

private extension Constants {
    static let cellReuseIdentifier = "RecipeCollectionViewCellSK"
}
