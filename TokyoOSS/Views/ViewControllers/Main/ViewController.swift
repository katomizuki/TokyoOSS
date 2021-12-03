import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth
import WebKit
import CoreLocation
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
    var webView:WKWebView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        // 3 WKWebView に Configuration を引き渡し initialize
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        // 4 WKUIDelegate の移譲先として self を登録
        webView.uiDelegate = self
        // 5 WKNavigationDelegate の移譲先として self を登録
        webView.navigationDelegate = self
        // 6 view に webView を割り当て
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = TimeLineCoordinator()
        coordinator?.navigationController = self.navigationController
//        setupCollectionView()
        let myURL = URL(string:"https://tokyo-oss-ad760.web.app")
        // 8 URLRequestオブジェクトを生成
        let myRequest = URLRequest(url: myURL!)

        // 9 URLを WebView にロード
        webView.load(myRequest)
        setupNav()
        checkAuth()
    }
    private func setupNav() {
        let item = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapRightButton))
        item.tintColor = appColor
        navigationItem.rightBarButtonItem = item
    }
    @objc private func didTapRightButton() {
        print(#function)
        performSegue(withIdentifier: "post", sender: nil)
    }
    private func setupCollectionView() {
        let nib = TimeLineCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: TimeLineCell.id)
       
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
//            let index = indexPath.row
//            let data = self.viewModel.dataList.value[index]
//            let string = String(data: data, encoding: .utf8)
//            let controller = TestViewController()
//            controller.modalPresentationStyle = .fullScreen
//            self.present(controller, animated: true, completion: nil)
//            self.coordinator?.eventOccurred(tap: .push, vc: self)
        }).disposed(by: disposeBag)
    }
    private func checkAuth() {
        
        if Auth.auth().currentUser == nil {
            print("アイウエオ")
            coordinator?.eventOccurred(tap: .perform, vc: self)
        } 
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 100, height: 300)
    }
}

extension ViewController: WKUIDelegate {
    // delegate
}

// MARK: - 11 WKWebView WKNavigation delegate
extension ViewController: WKNavigationDelegate {
    // delegate
}

