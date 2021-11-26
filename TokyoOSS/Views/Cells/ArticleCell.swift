import UIKit

class ArticleCell: UITableViewCell {
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
