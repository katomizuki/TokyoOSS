import UIKit
import RxSwift
import RxCocoa
import RxGesture
class RegisterController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var toLoginButton: UIButton!
    private let disposeBag = DisposeBag()
    private let emailDeleteButton = DeleteButton()
    private let passwordDeleteButton = DeleteButton()
    private let nameDeleteButton = DeleteButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    private func setupUI() {
        updateAuthencationTextField(tf: emailTextField, button: emailDeleteButton)
        updateAuthencationTextField(tf: nameTextField, button: nameDeleteButton)
        updateAuthencationTextField(tf: passwordTextField, button: passwordDeleteButton)
        passwordTextField.updateAuthTextFieldUI()
        emailTextField.updateAuthTextFieldUI()
        nameTextField.updateAuthTextFieldUI()
        emailDeleteButton.isHidden = true
        passwordDeleteButton.isHidden = true
        nameDeleteButton.isHidden = true
    }
    private func setupBinding() {
        let viewModel = RegisterViewModel(doneMainTap: registerButton.rx.tap.asSignal(), toLoginTap: toLoginButton.rx.tap.asSignal())
        // Inputs
        nameTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            viewModel.inputs.nameTextField.accept(text ?? "")
            self?.nameDeleteButton.isHidden = viewModel.outputs.isNameDeleteButtonHidden
            self?.nameTextField.layer.borderColor = viewModel.outputs.nameTextFieldBorderColor
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            viewModel.inputs.emailTextField.accept(text ?? "")
            self?.emailDeleteButton.isHidden = viewModel.outputs.isEmailDeleteButtonHidden
            self?.emailTextField.layer.borderColor = viewModel.outputs.emailTextFieldBorderColor
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            viewModel.inputs.passwordTextField.accept(text ?? "")
            self?.passwordDeleteButton.isHidden = viewModel.outputs.isPasswordDeleteButtonHidden
            self?.passwordTextField.layer.borderColor = viewModel.outputs.passwordTextFieldBorderColor
        }).disposed(by: disposeBag)

        // Outputs
        viewModel.outputs.isRegister.drive(onNext: { [weak self] result in
            self?.registerButton.backgroundColor = result ? .systemTeal : .lightGray
            self?.registerButton.isEnabled = result
        }).disposed(by: disposeBag)
        
        viewModel.outputs.toMain.subscribe(onNext:{ [weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true, completion: nil)
        }).disposed(by: disposeBag)

        
        viewModel.outputs.toLogin.subscribe(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
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
        
        nameTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.nameTextField.layer.borderColor = UIColor.systemTeal.cgColor
            }).disposed(by: disposeBag)
        
        emailDeleteButton.rx.tap.asDriver().drive(onNext:{ [weak self] _ in
            self?.emailTextField.text = ""
        }).disposed(by: disposeBag)
        
        passwordDeleteButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.passwordTextField.text = ""
        }).disposed(by: disposeBag)
        
        nameDeleteButton.rx.tap.asDriver().drive(onNext:{ [weak self] _ in
            self?.nameTextField.text = ""
        }).disposed(by: disposeBag)
    }
}


