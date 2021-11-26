import RxCocoa
import RxSwift
import Foundation
protocol RegisterViewModelInputs {
    var emailTextField:BehaviorRelay<String> { get }
    var passwordTextField:BehaviorRelay<String> { get }
    var nameTextField:BehaviorRelay<String> { get }
}
protocol RegisterViewModelOutputs {
    var isRegister:Driver<Bool> { get }
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
    
    init() {
        isRegister = Observable.combineLatest(emailTextField, passwordTextField,nameTextField)
            .map({ email,password,name -> Bool in
                return Validator.isEnableEmail(email: email) && Validator.isEnablePassWord(password: password) && name.count > 0
            }).asDriver(onErrorDriveWith: .empty())
    }
}


