import UIKit
import RxSwift
import RxCocoa
class PostViewController: UIViewController {
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
    
    private let disposeBag = DisposeBag()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        dismissButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

    }

    
}
