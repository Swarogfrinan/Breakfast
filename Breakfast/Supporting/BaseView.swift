import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewAppearance()
        setViewPosition()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Configure your baseview here.
    func setViewAppearance() { }
    
    /// Add and Layout your subviews here.
    func setViewPosition() { }
}
