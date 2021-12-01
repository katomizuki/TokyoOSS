import RxCocoa
import RxSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
protocol RegisterViewModelInputs {
    var emailTextField:BehaviorRelay<String> { get }
    var passwordTextField:BehaviorRelay<String> { get }
    var nameTextField:BehaviorRelay<String> { get }
    func register(completion:@escaping(Result<String,Error>)->Void)
}
protocol RegisterViewModelOutputs {
    var isRegister:Driver<Bool> { get }
    var toLogin:PublishRelay<Void> { get }
    var toMain:PublishRelay<Void> { get }
    var isEmailDeleteButtonHidden:Bool { get }
    var isNameDeleteButtonHidden:Bool { get }
    var isPasswordDeleteButtonHidden:Bool { get }
    var emailTextFieldBorderColor:CGColor { get }
    var nameTextFieldBorderColor:CGColor { get }
    var passwordTextFieldBorderColor:CGColor { get }
}
protocol RegisterViewModelType {
    var outputs:RegisterViewModelOutputs { get }
    var inputs:RegisterViewModelInputs { get }
}
final class RegisterViewModel:RegisterViewModelType,RegisterViewModelInputs,RegisterViewModelOutputs {
   
    var outputs: RegisterViewModelOutputs { return self }
    var inputs: RegisterViewModelInputs { return self }
    var emailTextField = BehaviorRelay<String>(value: "")
    var passwordTextField = BehaviorRelay<String>(value: "")
    var nameTextField = BehaviorRelay<String>(value: "")
    var isRegister: Driver<Bool>
    var toLogin = PublishRelay<Void>()
    var toMain = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    var isEmailDeleteButtonHidden: Bool {
        return emailTextField.value.count <= 0
    }
    var isNameDeleteButtonHidden: Bool {
        return nameTextField.value.count <= 0
    }
    var isPasswordDeleteButtonHidden: Bool {
        return passwordTextField.value.count <= 0
    }
    var emailTextFieldBorderColor: CGColor {
        return emailTextField.value.count <= 0 ? UIColor.darkGray.cgColor : appColor.cgColor
    }
    var nameTextFieldBorderColor: CGColor {
        return nameTextField.value.count <= 0 ? UIColor.darkGray.cgColor : appColor.cgColor
    }
    var passwordTextFieldBorderColor: CGColor {
        return passwordTextField.value.count <= 0 ? UIColor.darkGray.cgColor : appColor.cgColor
    }
    init(doneMainTap:Signal<Void>,toLoginTap:Signal<Void>) {
        isRegister = Observable.combineLatest(emailTextField, passwordTextField,nameTextField)
            .map({ email,password,name -> Bool in
                return Validator.isEnableEmail(email: email) && Validator.isEnablePassWord(password: password) && name.count > 0
            }).asDriver(onErrorDriveWith: .empty())
        
        toLoginTap.emit(onNext: { [weak self] _ in
            self?.outputs.toLogin.accept(())
        }).disposed(by: disposeBag)
        
        doneMainTap.emit(onNext: { [weak self] _ in
            self?.outputs.toMain.accept(())
        }).disposed(by: disposeBag)
    }
    
    func register(completion:@escaping(Result<String,Error>)->Void) {
        let email = emailTextField.value
        let name = nameTextField.value
        let password = passwordTextField.value
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else { return }
            FetchUser.sendUser(uid: uid, name: name, email: email) { error in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success("success!"))
            }
        }
    }
}


