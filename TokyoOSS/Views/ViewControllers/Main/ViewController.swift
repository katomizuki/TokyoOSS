import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth
final class ViewController: UIViewController, UIScrollViewDelegate,Coordinating {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.estimatedItemSize = .zero
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    var coordinator: Coordinator?
    private let viewModel = TimeLineViewModel(postAPI: FetchPost())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        checkAuth()
    }
    private func setupCollectionView() {
        let nib = TimeLineCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: TimeLineCell.id)
        coordinator = TimeLineCoordinator()
        coordinator?.navigationController = self.navigationController
        setupBinding()
    }
    private func setupBinding() {
        print(#function)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.timeLineList.bind(to: collectionView.rx.items(cellIdentifier: TimeLineCell.id, cellType: TimeLineCell.self)) {
            row ,blog ,cell in
            cell.configure(blog: blog)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            let index = indexPath.row
            let data = self.viewModel.dataList.value[index]
            let string = String(data: data, encoding: .utf8)
            print(string)
//            let controller = TestViewController(data: data)
//            self.present(controller, animated: true, completion: nil)
//            self.coordinator?.eventOccurred(tap: .push, vc: self)
        }).disposed(by: disposeBag)
    }
    private func checkAuth() {
        if Auth.auth().currentUser == nil {
            coordinator?.eventOccurred(tap: .perform, vc: self)
        } 
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 100, height: 300)
    }
}
