import UIKit
import RxSwift
import RxCocoa
final class PostViewController: UIViewController,Coordinating {
    // MARK: - Properties
    @IBOutlet private weak var pictureButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1
        }
    }
    private var viewModel:PostViewModel!
    private let disposeBag = DisposeBag()
    var coordinator: Coordinator?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        coordinator = MainCoordinator()
    }
    private func setupBinding() {
        viewModel = PostViewModel(tap: dismissButton.rx.tap.asSignal(),openTap:postButton.rx.tap.asSignal())
        
        viewModel.outputs.doneDismiss.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.eventOccurred(tap: .dismiss, vc: self!)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.donePost.subscribe(onNext: {[weak self] _ in
            self?.coordinator?.eventOccurred(tap: .dismiss, vc: self!)
        }).disposed(by: disposeBag)
    }

    
}
