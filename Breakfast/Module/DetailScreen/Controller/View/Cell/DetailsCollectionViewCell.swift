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
}
