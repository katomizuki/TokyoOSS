import UIKit
import RxSwift
import RxCocoa
import RxDataSources
final class ViewController: UIViewController, UIScrollViewDelegate {
   
    @IBOutlet private weak var collectionView: UICollectionView!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCollectionView()
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = TimeLineCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: TimeLineCell.id)
    }
}
extension ViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeLineCell.id, for: indexPath) as? TimeLineCell else { fatalError("can't make TimeLineCell") }
        return cell
    }
    
    
}
extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
}

