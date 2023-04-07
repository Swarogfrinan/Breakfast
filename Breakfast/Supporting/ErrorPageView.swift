import SnapKit
import UIKit

class ErrorPageView: UIView {
    
    var didPressButton: (() -> Void)?
    
    // MARK: - Properties
    
    private let errorBox = ErrorPageView.makeErrorBox()
    private let titleTextLabel = ErrorPageView.makeTitleLabel()
    private let descriptionTextLabel = ErrorPageView.makeDescriptionLabel()
    private let mainButton = ErrorPageView.makeRefreshButton()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect.zero)
        mainButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        setViewAppearance()
        setViewPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ErrorPageView {
    
    func setData(with title: String, message: String, buttonText: String) {
        titleTextLabel.text = title
        descriptionTextLabel.text = message
        mainButton.setTitle(buttonText, for: .normal)
    }
}

// MARK: - Actions

@objc
private extension ErrorPageView {
    
    func buttonPressed() {
        didPressButton?()
    }
}

// MARK: - Creating SubViews

private extension ErrorPageView {
    
    static func makeErrorBox() -> UIStackView {
        let errorBox = UIStackView()
        
        errorBox.alignment = .center
        errorBox.axis = .vertical
        errorBox.spacing = Constants.Design.spacingMain
        
        return errorBox
    }
    
    static func makeTitleLabel() -> UILabel {
        let titleTextLabel = UILabel()
        
        titleTextLabel.font = UIFont.big
        titleTextLabel.numberOfLines = .zero
        
        return titleTextLabel
    }
    
    static func makeDescriptionLabel() -> UILabel {
        let descriptionTextLabel = UILabel()
        
        descriptionTextLabel.numberOfLines = .zero
        descriptionTextLabel.textAlignment = .center
        descriptionTextLabel.font = UIFont.standart
        
        return descriptionTextLabel
    }
    
    static func makeRefreshButton() -> UIButton {
        let mainButton = UIButton(type: .system)
        
        mainButton.backgroundColor = .none
        mainButton.titleLabel?.font = UIFont.standart
        mainButton.setTitleColor(.systemBlue, for: .normal)
        mainButton.setTitleColor(.black, for: .selected)
        mainButton.layer.cornerRadius = Constants.Design.cornerRadiusError
        mainButton.layer.borderWidth = Constants.Design.borderWidth
        mainButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        return mainButton
    }
}

// MARK: - Setting Views

private extension ErrorPageView {
    
    func setViewAppearance() {
        isHidden = true
        backgroundColor = .white
    }
    
    func setViewPosition() {
        addSubview(errorBox)
        errorBox.snp.makeConstraints { make in
            make.leading.equalTo(Constants.Design.basicInset)
            make.trailing.equalTo(-Constants.Design.basicInset)
            make.top.greaterThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.Design.basicInset)
            make.centerY.equalToSuperview()
        }
        
        [titleTextLabel, descriptionTextLabel, mainButton].forEach { errorBox.addArrangedSubview($0) }
        mainButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Button.height)
            make.width.equalTo(errorBox.snp.width).dividedBy(Constants.Button.divison)
        }
    }
}

// MARK: - Constants

private extension Constants {
    
    struct Button {
        static let height = CGFloat(45)
        static let divison = CGFloat(1.15)
    }
}
