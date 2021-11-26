import UIKit
import Foundation

extension UIViewController {
    func updateAuthencationTextField(tf:UITextField,button:UIButton) {
        let view = UIView()
        view.setDimensions(height: 40, width: 40)
        tf.rightView = view
        tf.rightViewMode = .always
        view.addSubview(button)
        button.setDimensions(height: 40, width: 40)
    }
}
