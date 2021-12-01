import UIKit
import SDWebImage
final class TimeLineCell: UICollectionViewCell {
    static let id = "TimeLineCell"
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var timeLineImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    private let notLikeImage = UIImage(systemName: "heart")
    private let likeImage = UIImage(systemName: "heart.fill")
    var isLiked = false
    private let viewModel = TimeLineViewModel(postAPI: FetchPost())
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.tintColor = appColor
        timeLineImageView.backgroundColor = appColor
    }
    static func nib()->UINib {
        return UINib(nibName: "TimeLineCell", bundle: nil)
    }

    @IBAction func didTapLikeButton(_ sender: Any) {
        viewModel.didTapLikeButton()
        likeButton.setImage(viewModel.currentImage, for: .normal)
    }
    func configure(blog:Blogs) {
        titleLabel.text = blog.title
        guard let mainUrl = blog.mainImage else { return }
        contentLabel.text = blog.blocks[0].data.text
        if mainUrl == "" {
            timeLineImageView.image = UIImage(systemName: "person.fill")
        } else {
            guard let url = URL(string: mainUrl) else { return }
            timeLineImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
