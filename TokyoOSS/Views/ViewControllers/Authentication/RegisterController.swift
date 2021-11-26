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
    private let viewModel = RegisterViewModel()
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
        let emailRightView = UIView()
        emailRightView.setDimensions(height: 40, width: 40)
        emailTextField.rightView = emailRightView
        emailTextField.rightViewMode = .always
        emailRightView.addSubview(emailDeleteButton)
        emailDeleteButton.setDimensions(height: 40, width: 40)
        let nameRightView = UIView()
        nameRightView.setDimensions(height: 40, width: 40)
        nameTextField.rightView = nameRightView
        nameTextField.rightViewMode = .always
        nameRightView.addSubview(nameDeleteButton)
        nameDeleteButton.setDimensions(height: 40, width: 40)
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
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.darkGray.cgColor
        nameDeleteButton.isHidden = true
        emailDeleteButton.isHidden = true
        passwordDeleteButton.isHidden = true
    }
    private func setupBinding() {
        
        // Inputs
        nameTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.nameTextField.accept(text ?? "")
            self?.nameDeleteButton.isHidden = text?.count ?? 0 <= 0
            self?.nameTextField.layer.borderColor = text?.count ?? 0 <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.emailTextField.accept(text ?? "")
            self?.emailDeleteButton.isHidden = text?.count ?? 0 <= 0
            self?.emailTextField.layer.borderColor = text?.count ?? 0 <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.passwordTextField.accept(text ?? "")
            self?.passwordDeleteButton.isHidden = text?.count ?? 0 <= 0
            self?.passwordTextField.layer.borderColor = text?.count ?? 0 <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
        }).disposed(by: disposeBag)

        // Outputs
        viewModel.outputs.isRegister.drive(onNext: { [weak self] result in
            self?.registerButton.backgroundColor = result ? .systemTeal : .lightGray
            self?.registerButton.isEnabled = result
        }).disposed(by: disposeBag)

        
        registerButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        toLoginButton.rx.tap.asDriver().drive(onNext:{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
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
        
        nameTextField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.nameDeleteButton.isHidden = false
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
