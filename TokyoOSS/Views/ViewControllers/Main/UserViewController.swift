import UIKit
import RxSwift
import RxCocoa
final class UserViewController: UIViewController,Coordinating {
    
    @IBOutlet private weak var userTableView: UITableView!
    private let disposeBag = DisposeBag()
    var coordinator: Coordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        coordinator = UserCoordinator()
        coordinator?.navigationController = self.navigationController
    }
    private func setupTableView() {
        let nib = ArticleCell.nib()
        userTableView.register(nib, forCellReuseIdentifier: ArticleCell.id)
        userTableView.delegate = self
        userTableView.dataSource = self
    }
}
extension UserViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as? ArticleCell else { fatalError() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
extension UserViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        coordinator?.eventOccurred(tap: .push, vc: self)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UserHeaderView(frame: .zero)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
