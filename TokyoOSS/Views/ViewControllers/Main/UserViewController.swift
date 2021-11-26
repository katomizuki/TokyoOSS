import UIKit
import RxSwift
import RxCocoa
final class UserViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var userTableView: UITableView!
    private let items = Observable.just(["item 1","item 2","item 3"])
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        let nib = ArticleCell.nib()
        userTableView.register(nib, forCellReuseIdentifier: ArticleCell.id)
        items.bind(to: userTableView
                    .rx
                    .items(cellIdentifier: ArticleCell.id)) {
            (tv, items, cell) in
            cell.textLabel?.text = items
        }.disposed(by: disposeBag)
    }

}
