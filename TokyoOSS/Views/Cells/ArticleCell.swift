import UIKit

final class ArticleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
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
    
}
