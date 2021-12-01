import UIKit
import RxSwift
import RxCocoa
import RxGesture
final class LoginController: UIViewController,Coordinating {
   
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alreadyButton: UIButton!
    private let disposeBag = DisposeBag()
    private let emailDeleteButton = DeleteButton()
    private let passwordDeleteButton = DeleteButton()
    var coordinator: Coordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    private func setupUI() {
        updateAuthencationTextField(tf: emailTextField, button: emailDeleteButton)
        updateAuthencationTextField(tf: passwordTextField, button: passwordDeleteButton)
        passwordTextField.updateAuthTextFieldUI()
        emailTextField.updateAuthTextFieldUI()
        coordinator = AuthCoordinator()
        coordinator?.navigationController = self.navigationController
    }
    private func setupBinding() {
        // Inputs
        let viewModel = LoginViewModel(doneMainTap: loginButton.rx.tap.asSignal(),doneRegisterTap: alreadyButton.rx.tap.asSignal())
        
        passwordTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            viewModel.inputs.passwordTextField.accept(text ?? "")
            self?.passwordDeleteButton.isHidden = viewModel.outputs.isPasswordButtonHidden
            self?.passwordTextField.layer.borderColor = viewModel.outputs.passwordBorderColor
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            viewModel.inputs.emailTextField.accept(text ?? "")
            self?.emailDeleteButton.isHidden = viewModel.outputs.isEmailButtonHidden
            self?.emailTextField.layer.borderColor = viewModel.outputs.emailBorderColor
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.passwordTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        emailTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.emailTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        // Outputs
        viewModel.outputs.isLogin.drive(onNext: { [weak self] result in
            self?.loginButton.backgroundColor = result ? .systemTeal : .lightGray
            self?.loginButton.isEnabled = result
        }).disposed(by: disposeBag)
        
        viewModel.outputs.toMain.subscribe(onNext: { [weak self]_ in
            viewModel.inputs.login { result in
                switch result {
                case .success:
                    self?.coordinator?.eventOccurred(tap: .dismiss, vc: self!)
                case .failure(let error):
                    print(error)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.outputs.toRegister.subscribe(onNext: { [weak self] _ in
            self?.coordinator?.eventOccurred(tap: .push,vc: self!)
        }).disposed(by: disposeBag)

        emailDeleteButton.rx.tap.asDriver().drive(onNext:{ [weak self] _ in
            self?.emailTextField.text = ""
        }).disposed(by: disposeBag)
        
        passwordDeleteButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.passwordTextField.text = ""
        }).disposed(by: disposeBag)

    }
}
