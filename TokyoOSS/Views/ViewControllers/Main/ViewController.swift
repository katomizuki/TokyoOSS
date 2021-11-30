import UIKit
import RxSwift
import RxCocoa
import RxDataSources
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
    private let items = Observable.just(["😆","⚡️","✊"])
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCollectionView()
        FetchPost().getBlogsData().subscribe(onSuccess: { blogs in
            print(blogs)
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposeBag)


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
        items.bind(to: collectionView.rx.items(cellIdentifier: TimeLineCell.id, cellType: TimeLineCell.self)) { row, element, cell in
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            let index = indexPath.row
            self.coordinator?.eventOccurred(tap: .push, vc: self)
        }).disposed(by: disposeBag)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 100, height: 300)
    }
}
