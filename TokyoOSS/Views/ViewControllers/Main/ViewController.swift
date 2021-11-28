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
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCollectionView()
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = TimeLineCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: TimeLineCell.id)
        coordinator = TimeLineCoordinator()
        coordinator?.navigationController = self.navigationController
    }
}
extension ViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.eventOccurred(tap: .push, vc: self)
    }
}
extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeLineCell.id, for: indexPath) as? TimeLineCell else { fatalError("can't make TimeLineCell") }
        cell.delegate = self
        return cell
    }
}
extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 100, height: 300)
    }
}
extension ViewController:TimeLineCellProtocol {
    func timeLineCell(_ cell: TimeLineCell, didTapLikeButton post: Post) {
        print(#function)
    }
}

