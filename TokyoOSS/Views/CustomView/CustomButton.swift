
import Foundation
import UIKit

class DeleteButton:UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let image = UIImage(systemName: "multiply.circle.fill")?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        tintColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
