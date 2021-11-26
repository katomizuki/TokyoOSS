import UIKit
protocol TimeLineCellProtocol {
    func timeLineCell(_ cell:TimeLineCell,didTapLikeButton post:Post)
}
class TimeLineCell: UICollectionViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLineImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }   

    @IBAction func didTapLikeButton(_ sender: Any) {
    }
}
