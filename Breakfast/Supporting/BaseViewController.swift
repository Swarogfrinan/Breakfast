import UIKit

class BaseViewController<View: UIView>: UIViewController {
    // swiftlint:disable force_cast
    var selfView: View { view as! View }
    // swiftlint:enable force_cast
    override func loadView() {
        view = View()
    }
}
