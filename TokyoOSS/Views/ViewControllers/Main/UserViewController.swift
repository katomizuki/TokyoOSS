import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth
import SDWebImage
struct UserSectionModel {
    var header:String
    var items:[Post]
}
final class UserViewController: UIViewController,Coordinating, UIScrollViewDelegate {
    
    @IBOutlet private weak var userTableView: UITableView!
    private let disposeBag = DisposeBag()
    var coordinator: Coordinator?
    private let userView = UserHeaderView()
    private let picker = UIImagePickerController()
    private var currentImage:UIImage?
    private var viewModel:UserViewModel?
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
        userTableView.rowHeight = 100
        setupBinding()
    }
    private func setupUI() {
        picker.delegate = self
        view.addSubview(userView)
        userView.anchor(top:view.safeAreaLayoutGuide.topAnchor,leading:view.leadingAnchor,bottom:userTableView.topAnchor,
                        trailing: view.trailingAnchor,paddingTop: 5,paddingLeft: 25,paddingRight: 25)
    }
    
    private func setupBinding() {
        
        userTableView.rx.setDelegate(self).disposed(by: disposeBag)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        viewModel = UserViewModel(userAPI: FetchUser(), userId: userId, blogsAPI: FetchPost())
        viewModel?.blogs.bind(to: userTableView.rx.items(cellIdentifier: ArticleCell.id, cellType: ArticleCell.self)) {
            row , blog ,cell in
            cell.configure(blog: blog)
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        userView.userImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.picker, animated: true, completion: nil)
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)



        userTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
              
                guard let cell = self?.userTableView.cellForRow(at: indexPath) as? ArticleCell else { return }

                let message = cell.publicLabel.text == "公開中" ? "下書き":"公開中"
                let showVC = UIAlertController(title: "「\(cell.publicLabel.text ?? "")」から状態を変更しますか？", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self?.viewModel?.didTapCell(index: indexPath.row)
                    cell.publicLabel.text = message
                })
                showVC.addAction(alertAction)
                self?.present(showVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel?.outputs.isCompleted.subscribe(onNext: { _ in
        } ,onError: { error in
            print(error)
        }).disposed(by: disposeBag)
        
        viewModel?.outputs.user.subscribe(onNext: { user in
            let urlString = user.icon
            if urlString != "" {
                guard let url = URL(string: urlString) else { return }
                self.userView.userImageView.sd_setImage(with: url, completed: nil)
            }
            self.userView.userLabel.text = user.name
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)

    }
    
}

extension UserViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        guard let image = info[.originalImage] as? UIImage else { return }
        print(image)
        userView.userImageView.image = image
        currentImage = image
        viewModel?.inputs.saveImage(image: image, completion: { error in
            if let error = error {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}
