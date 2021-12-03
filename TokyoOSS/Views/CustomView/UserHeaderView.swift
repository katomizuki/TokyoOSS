import UIKit

final class UserHeaderView: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let view = UINib(nibName: "UserHeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        setupUI()
        addSubview(view)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        print(#function)
        userImageView.layer.cornerRadius = 45
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = appColor
        
    }
}
