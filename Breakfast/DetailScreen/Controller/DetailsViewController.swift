import Kingfisher
import UIKit

class DetailsViewController: BaseViewController<DetailsView> {
    
    // MARK: - Properties
    
    let alertView: ErrorPageView
    let viewModel: DetailsViewModel
    
    // MARK: - Initialization
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        alertView = ErrorPageView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRecipeCollectionView()
        setRecommendationsCollectionView()
        bindToViewModel()
        viewModel.reloadData()
        
        setCustomAlert(alertView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            removeCustomAlert(alertView)
            viewModel.viewWillDisappear()
        }
    }
}

// MARK: - Public Methods

extension DetailsViewController {
    
    func setRecipeData(recipe: DataForDetails) {
        if recipe.imageLinks.count < 2 {
            selfView.pageControl.isHidden = true
        } else {
            selfView.pageControl.isHidden = false
            selfView.pageControl.numberOfPages = recipe.imageLinks.count
        }
        
        if recipe.similarRecipes.isEmpty {
            selfView.recommendedTitleLabel.isHidden = true
            selfView.recommendationCollectionView.isHidden = true
        } else {
            selfView.recommendedTitleLabel.isHidden = false
            selfView.recommendedTitleLabel.text = Constants.recommended
            
            selfView.recommendationCollectionView.isHidden = false
            selfView.recommendationCollectionView.reloadData()
        }
        
        selfView.recipeNameLabel.text = recipe.name
        selfView.instructionTextLabel.text = recipe.instructions
        selfView.descriptionTextLabel.text = recipe.description
        selfView.timestampLabel.text = recipe.lastUpdated
        selfView.difficultyTitleLabel.text = Constants.difficulty
        selfView.instructionTitleLabel.text = Constants.instructions
        
        selfView.difficultyView.difficulty = recipe.difficultyLevel
        
        selfView.recipeCollectionView.reloadData()
        
    }
}

// MARK: - CustomAlertDisplaying

extension DetailsViewController: CustomAlertDisplaying {
    func handleButtonTap() {
        viewModel.reloadData()
    }
}

// MARK: - CollectionView Delegate

extension DetailsViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if selfView.recipeCollectionView.frame.size.width != 0 {
            selfView.pageControl.currentPage =
            Int(scrollView.contentOffset.x / selfView.recipeCollectionView.frame.size.width)
        }
    }
}

// MARK: - CollectionView DataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selfView.recipeCollectionView {
            return viewModel.recipeImages.count
        } else {
            return viewModel.recipeRecommendationImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selfView.recipeCollectionView {
            return viewModel.recipeImages[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return viewModel.recipeRecommendationImages[indexPath.row].dequeueCell(collectionView: collectionView,
                                                                                   indexPath: indexPath)
        }
    }
}

// MARK: - CollectionView FlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == selfView.recipeCollectionView {
            return collectionView.frame.size
        } else {
            var newSize = CGSize()
            newSize.width = (self.view.frame.width / 3) * 2
            newSize.height = collectionView.frame.height
            return newSize
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == selfView.recipeCollectionView {
            return Constants.spaceRecipeImages
        } else {
            return Constants.spaceRecipeRecommendations
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selfView.recommendationCollectionView {
            viewModel.recipeRecommendationImages[indexPath.row].cellSelected()
        }
    }
}

// MARK: - Private Methods

private extension DetailsViewController {
    
    func setRecipeCollectionView() {
        selfView.recipeCollectionView.delegate = self
        selfView.recipeCollectionView.dataSource = self
        ImageCollectionViewCellViewModel.registerCell(collectionView: self.selfView.recipeCollectionView)
        selfView.recipeCollectionView.reloadData()
    }
    
    func setRecommendationsCollectionView() {
        selfView.recommendationCollectionView.delegate = self
        selfView.recommendationCollectionView.dataSource = self
        RecommendedCollectionViewCell.registerCell(collectionView: self.selfView.recommendationCollectionView)
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
    
    func didFinishUpdating() {
        if let recipe = viewModel.recipe {
            setRecipeData(recipe: recipe)
            selfView.recipeCollectionView.reloadData()
            hideCustomAlert(alertView)
        }
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
    static let spaceRecipeImages = CGFloat(0)
    static let spaceRecipeRecommendations = CGFloat(20)
    static let difficulty = "Difficulty: "
    static let instructions = "Instruction: "
    static let recommended = "Recommended: "
}
