import UIKit

class UserHeaderView: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let view = UINib(nibName: "UserHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
