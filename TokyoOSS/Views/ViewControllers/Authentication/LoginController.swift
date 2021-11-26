import UIKit
import RxSwift
import RxCocoa
import RxGesture
class LoginController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alreadyButton: UIButton!
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    private let emailDeleteButton = DeleteButton()
    private let passwordDeleteButton = DeleteButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    private func setupUI() {
        let emailRightView = UIView()
        emailRightView.setDimensions(height: 40, width: 40)
        emailTextField.rightView = emailRightView
        emailTextField.rightViewMode = .always
        emailRightView.addSubview(emailDeleteButton)
        emailDeleteButton.setDimensions(height: 40, width: 40)
        let passwordRightView = UIView()
        passwordRightView.setDimensions(height: 40, width: 40)
        passwordTextField.rightView = passwordRightView
        passwordTextField.rightViewMode = .always
        passwordRightView.addSubview(passwordDeleteButton)
        passwordDeleteButton.setDimensions(height: 40, width: 40)
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.borderWidth = 1
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    private func setupBinding() {
        // Inputs
        passwordTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.passwordTextField.accept(text ?? "")
            self?.passwordDeleteButton.isHidden = text?.count ?? 0 <= 0
            self?.passwordTextField.layer.borderColor = text?.count ?? 0 <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.emailTextField.accept(text ?? "")
            self?.emailDeleteButton.isHidden = text?.count ?? 0 <= 0
            self?.emailTextField.layer.borderColor = text?.count ?? 0 <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.passwordDeleteButton.isHidden = false
                self?.passwordTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        emailTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.emailDeleteButton.isHidden = false
                self?.emailTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        // Outputs
        viewModel.outputs.isLogin.drive(onNext: { [weak self] result in
            self?.loginButton.backgroundColor = result ? .systemTeal : .lightGray
            self?.loginButton.isEnabled = result
        }).disposed(by: disposeBag)

        loginButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        alreadyButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterController") as? RegisterController else { return }
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        
        emailDeleteButton.rx.tap.asDriver().drive(onNext:{ [weak self] _ in
            self?.emailTextField.text = ""
        }).disposed(by: disposeBag)
        
        passwordDeleteButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.passwordTextField.text = ""
        }).disposed(by: disposeBag)
    }
}
