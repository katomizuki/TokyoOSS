import RxCocoa
import RxSwift
import Foundation
protocol LoginViewModelInputs {
    var emailTextField:BehaviorRelay<String> { get }
    var passwordTextField:BehaviorRelay<String> { get }
}
protocol LoginViewModelOutputs {
    var isLogin:Driver<Bool> { get }
}
protocol LoginViewModelType {
    var outputs:LoginViewModelOutputs { get }
    var inputs:LoginViewModelInputs { get }
}
final class LoginViewModel:LoginViewModelType,LoginViewModelInputs,LoginViewModelOutputs {
    
    var outputs: LoginViewModelOutputs { return self }
    var inputs: LoginViewModelInputs { return self }
    var emailTextField = BehaviorRelay<String>(value: "")
    var passwordTextField = BehaviorRelay<String>(value: "")
    var isLogin: Driver<Bool>
    
    init() {
        isLogin = Observable.combineLatest(emailTextField, passwordTextField)
            .map({ email,password -> Bool in
                return Validator.isEnableEmail(email: email) && Validator.isEnablePassWord(password: password)
            }).asDriver(onErrorDriveWith: .empty())
    }
}

struct Validator {
    static func isEnableEmail(email: String) -> Bool {
        let args = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let validation = NSPredicate(format: "SELF MATCHES %@", args)
        return validation.evaluate(with: email)
    }
    static func isEnablePassWord(password: String)-> Bool {
        let args = "^(?=.*?[A-Za-z])(?=.*?[0-9])[A-Za-z0-9]{8,}$"
        let validation = NSPredicate(format: "SELF MATCHES %@", args)
        return validation.evaluate(with: password)
    }
}
