import UIKit

extension UIView {
    
    func setupGradient(frame: CGRect, colors: [CGColor], locations: [NSNumber]) {
            let gradientView = UIView(frame: frame)
            let gradient = CAGradientLayer()
            gradient.colors = colors
            gradient.frame = gradientView.bounds
            gradient.locations = locations
            gradientView.layer.insertSublayer(gradient, at: 0)
            self.addSubview(gradientView)
            self.bringSubviewToFront(gradientView)
        }
}
