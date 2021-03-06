import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
protocol UserViewModelInputs {
    func saveImage(image:UIImage,completion:@escaping (Error?)->Void)
}
protocol UserViewModelOutputs {
    var isError:BehaviorRelay<Bool> { get }
    var user:PublishRelay<User> { get }
    var blogs:BehaviorRelay<[Blogs]> { get }
    var isCompleted:PublishRelay<Void> { get }
}
protocol UserViewModelType {
    var inputs:UserViewModelInputs { get }
    var outputs:UserViewModelOutputs { get }
    
}
final class UserViewModel:UserViewModelType, UserViewModelInputs, UserViewModelOutputs {
    var isCompleted = PublishRelay<Void>()
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
    var userAPI:FetchUserProtocol!
    var postAPI:FetchPostProtocol!
    private let disposeBag = DisposeBag()
    var userId:String?
    var isError = BehaviorRelay<Bool>(value: false)
    var user = PublishRelay<User>()
    var blogs = BehaviorRelay<[Blogs]>(value: [])
    init(userAPI:FetchUserProtocol,userId:String,blogsAPI:FetchPostProtocol) {
        self.userAPI = userAPI
        self.userId = userId
        self.postAPI = blogsAPI
       postAPI.getMyBlogs().subscribe(onSuccess: { blogs in
           print(blogs,"⚡️")
            self.blogs.accept(blogs)
        }, onFailure: { error in
            self.isError.accept(true)
        }).disposed(by: disposeBag)
        userAPI.fetchUser(userId: userId).subscribe(onSuccess: { [weak self] user in
            print(user,"✊")
            self?.user.accept(user)
        }, onFailure: { [weak self] error in
            self?.isError.accept(true)
        }).disposed(by: disposeBag)
    }
    func showUser() {
        print(#function)
        userAPI.fetchUser(userId: userId ?? "").subscribe(onSuccess: { [weak self] user in
            self?.user.accept(user)
        }, onFailure: { [weak self] error in
            self?.isError.accept(true)
        }).disposed(by: disposeBag)
    }
    func didTapCell(index:Int) {
        let blog = blogs.value[index]
        postAPI.updateFsData(blogs: blog) { error in
            if let error = error {
                print(error)
                return
            }
            self.isCompleted.accept(())
        }
    }
    func saveImage(image:UIImage,completion:@escaping (Error?)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        StorageService.upload(image: image) { result in
            switch result {
            case .success(let urlString):
                self.userAPI.updateIcon(uid: uid, iconUrl: urlString,completion: completion)
            case .failure(let error):
                print(error)
            }
        }
    }

}
