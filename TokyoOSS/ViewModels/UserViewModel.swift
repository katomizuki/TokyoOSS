import Foundation
import RxSwift
import RxCocoa
protocol UserViewModelInputs {
    
}
protocol UserViewModelOutputs {
    var isError:BehaviorRelay<Bool> { get }
    var user:PublishRelay<User> { get }
}
protocol UserViewModelType {
    var inputs:UserViewModelInputs { get }
    var outputs:UserViewModelOutputs { get }
}
final class UserViewModel:UserViewModelType, UserViewModelInputs, UserViewModelOutputs {
    
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
    var userAPI:FetchUserProtocol!
    private let disposeBag = DisposeBag()
    var userId:String?
    var isError = BehaviorRelay<Bool>(value: false)
    var user = PublishRelay<User>()
    init(userAPI:FetchUserProtocol,userId:String) {
        self.userAPI = userAPI
        self.userId = userId
    }
    func showUser() {
        print(#function)
        userAPI.fetchUser(userId: userId ?? "").subscribe(onSuccess: { [weak self] user in
            self?.user.accept(user)
        }, onFailure: { [weak self] error in
            self?.isError.accept(true)
        }).disposed(by: disposeBag)
    }
}
