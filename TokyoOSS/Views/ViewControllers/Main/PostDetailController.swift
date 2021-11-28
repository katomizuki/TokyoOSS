import UIKit
import RxSwift
import RxCocoa
import RxGesture
class PostDetailController: UIViewController {
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postDayLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postContentLabel: UITextView!
    @IBOutlet weak var likeCountLabel: UILabel!
    private let disposeBag = DisposeBag()
    private var isLiked = false
    private let viewModel = PostDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        likeImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapLike()
                self?.likeImageView.image = self?.viewModel.currentImage
            }).disposed(by: disposeBag)
    }
}
