import RxCocoa
import RxSwift
import Foundation
protocol LoginViewModelInputs {
    var emailTextField:BehaviorRelay<String> { get }
    var passwordTextField:BehaviorRelay<String> { get }
}
protocol LoginViewModelOutputs {
    var isLogin:Driver<Bool> { get }
    var toMain:PublishRelay<Void> { get }
    var toRegister:PublishRelay<Void> { get }
    var isEmailButtonHidden:Bool { get }
    var isPasswordButtonHidden:Bool { get }
    var emailBorderColor:CGColor { get }
    var passwordBorderColor:CGColor { get }
}
protocol LoginViewModelType {
    var outputs:LoginViewModelOutputs { get }
    var inputs:LoginViewModelInputs { get }
}
final class LoginViewModel:LoginViewModelType,LoginViewModelInputs,LoginViewModelOutputs {
    
    var toRegister = PublishRelay<Void>()
    var toMain = PublishRelay<Void>()
    var outputs: LoginViewModelOutputs { return self }
    var inputs: LoginViewModelInputs { return self }
    var emailTextField = BehaviorRelay<String>(value: "")
    var passwordTextField = BehaviorRelay<String>(value: "")
    var isEmailButtonHidden:Bool {
        return emailTextField.value.count <= 0
    }
    var isPasswordButtonHidden: Bool {
        return passwordTextField.value.count <= 0
    }
    var emailBorderColor: CGColor {
        return emailTextField.value.count <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
    }
    var passwordBorderColor: CGColor {
        return passwordTextField.value.count <= 0 ? UIColor.darkGray.cgColor : UIColor.systemTeal.cgColor
    }
    
    private let disposeBag = DisposeBag()
    var isLogin: Driver<Bool>
    init(doneMainTap:Signal<Void>,doneRegisterTap:Signal<Void>) {
        isLogin = Observable.combineLatest(emailTextField, passwordTextField)
            .map({ (email,password) -> Bool in
                return Validator.isEnableEmail(email: email) && Validator.isEnablePassWord(password: password)
            }).asDriver(onErrorDriveWith: .empty())
        doneMainTap.emit(onNext: { [weak self] _ in
            self?.outputs.toMain.accept(())
        }).disposed(by: disposeBag)
        doneRegisterTap.emit(onNext: { [weak self] _ in
            self?.outputs.toRegister.accept(())
        }).disposed(by: disposeBag)
    }
}


