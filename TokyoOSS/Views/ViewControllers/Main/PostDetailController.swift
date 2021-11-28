import UIKit

class PostDetailController: UIViewController {
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postDayLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postContentLabel: UITextView!
    @IBOutlet weak var likeCountLabel: UILabel!
    private var isLiked = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func didTapLikeImageView(_ sender: Any) {
        print(#function)
        isLiked.toggle()
        if isLiked {
            likeImageView.image = UIImage(systemName: "heart.fill")
        } else {
            likeImageView.image = UIImage(systemName: "heart")
        }
    }
    
}
