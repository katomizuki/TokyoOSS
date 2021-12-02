import UIKit
import SDWebImage
final class ArticleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    static let id = "ArticleCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func nib()->UINib {
        return UINib(nibName: "ArticleCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(blog:Blogs) {
        titleLabel.text = blog.title
        if let urlString = blog.mainImage {
            guard let url = URL(string: urlString) else { return }
            blogImageView.sd_setImage(with: url, completed: nil)
        }
        if let bool = blog.isPublic {
            publicLabel.text = bool ? "公開中" : "下書き"
        }
    }
    
}
