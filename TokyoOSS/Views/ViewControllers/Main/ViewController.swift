import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class ViewController: UIViewController, UIScrollViewDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCollectionView()
    }
    private func setupCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    


}


