import SnapKit
import UIKit

final class DifficultyView: UIView {
    
    // MARK: - Views
    
    private let difficultyStackView = UIStackView()
    
    // MARK: - Properties
    
    var difficulty: Int = .zero {
        didSet {
            difficultyStackView.arrangedSubviews.forEach { view in
                difficultyStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            for _ in .zero..<difficulty {
                let image = R.image.shapeTrue()
                let imageView = UIImageView(image: image)
                difficultyStackView.addArrangedSubview(imageView)
            }
            
            for _ in difficulty..<Constants.maxDifficultyStarAmount {
                let image = R.image.shapeFalse()
                let imageView = UIImageView(image: image)
                difficultyStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        setViewPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Creating SubViews

private extension DifficultyView {
    
    static func makeDifficultyImagesCollection() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = Constants.DifficultyImageCollection.spacing
        
        return stackView
    }
}

// MARK: - Setting Views

private extension DifficultyView {
    
    func setViewPosition() {
        addSubview(difficultyStackView)
        difficultyStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Constants

private extension Constants {
    
    static let maxDifficultyStarAmount = 5
    
    struct DifficultyImageCollection {
        static let spacing = CGFloat(20)
    }
}

