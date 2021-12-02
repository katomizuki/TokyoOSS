import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth
struct UserSectionModel {
    var header:String
    var items:[Post]
}
final class UserViewController: UIViewController,Coordinating, UIScrollViewDelegate {
    
    @IBOutlet private weak var userTableView: UITableView!
    private let disposeBag = DisposeBag()
    var coordinator: Coordinator?
    private let userView = UserHeaderView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        coordinator = UserCoordinator()
        coordinator?.navigationController = self.navigationController
        setupUI()
    }
    private func setupTableView() {
        let nib = ArticleCell.nib()
        userTableView.register(nib, forCellReuseIdentifier: ArticleCell.id)
        userTableView.rowHeight = 60
        setupBinding()
    }
    private func setupUI() {
        view.addSubview(userView)
        userView.anchor(top:view.safeAreaLayoutGuide.topAnchor,leading:view.leadingAnchor,bottom:userTableView.topAnchor,
                        trailing: view.trailingAnchor,paddingTop: 5,paddingLeft: 25,paddingRight: 25)
    }
    
    private func setupBinding() {
        
        userTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
      

        guard let userId = Auth.auth().currentUser?.uid else { return }
        let viewModel = UserViewModel(userAPI: FetchUser(), userId: userId, blogsAPI: FetchPost())
        viewModel.blogs.bind(to: userTableView.rx.items(cellIdentifier: ArticleCell.id, cellType: ArticleCell.self)) {
            row , blog ,cell in
            cell.titleLabel.text = blog.title
        }.disposed(by: disposeBag)

        userTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.coordinator?.eventOccurred(tap: .push, vc: self)
            }).disposed(by: disposeBag)
    }
}

