import UIKit

final class ImageCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    let data: String
    
    // MARK: - Initialization
    
    init(imageLink: String) {
        self.data = imageLink
    }
    
    // MARK: - Actions
    
    var didReceiveError: ((String) -> Void)?
    var didUpdate: ((ImageCollectionViewCellViewModel) -> Void)?
    var didSelectImage: ((String) -> Void)?
    
}

// MARK: - CollectionViewCellRepresentable

extension ImageCollectionViewCellViewModel: CollectionViewCellRepresentable {
    static func registerCell(collectionView: UICollectionView) {
        DetailsCollectionViewCell.registerCell(collectionView: collectionView)
    }
    
    func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DetailsCollectionViewCell.dequeueCell(collectionView: collectionView, indexPath: indexPath)
        cell.setCellData(viewModel: self)
        return cell
    }
    
    func cellSelected() {
        self.didSelectImage?(data)
    }
}
