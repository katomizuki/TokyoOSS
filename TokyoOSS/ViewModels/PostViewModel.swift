import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseAuth
protocol PostViewModelInputs {
    var titleTextField:BehaviorRelay<String> { get }
    var contentTextView:BehaviorRelay<String> { get }
    func post(image:UIImage,completion:@escaping(Result<String,Error>)->Void) 
}
protocol PostViewModelOutputs {
    var doneDismiss:PublishRelay<Void> { get }
    var donePost:PublishRelay<Void> { get }
    var toPhotoLibrary:PublishRelay<Void> { get }
    var isPlaceHolderLabelHidden:Bool { get }
    var titleBorderColor:CGColor { get }
    var textViewBorderColor:CGColor { get }
    var textViewCount:String { get }
    var user:PublishRelay<User> { get }
}
protocol PostViewModelType {
    var inputs:PostViewModelInputs { get }
    var outputs:PostViewModelOutputs { get }
}
final class PostViewModel:PostViewModelType,PostViewModelInputs,PostViewModelOutputs {
    var lat:Double = 0
    var lng:Double = 0
    var titleTextField = BehaviorRelay<String>(value: "")
    var contentTextView = BehaviorRelay<String>(value: "")
    var inputs: PostViewModelInputs { return self }
    var outputs: PostViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    var doneDismiss = PublishRelay<Void>()
    var donePost = PublishRelay<Void>()
    var toPhotoLibrary = PublishRelay<Void>()
    var isPlaceHolderLabelHidden: Bool {
        return contentTextView.value.count > 0
    }
    var titleBorderColor: CGColor {
        return titleTextField.value.count <= 0 ? UIColor.lightGray.cgColor : UIColor.systemTeal.cgColor
    }
    var textViewBorderColor: CGColor {
        return contentTextView.value.count <= 0 ? UIColor.lightGray.cgColor : UIColor.systemTeal.cgColor
    }
    var textViewCount: String {
        return "\(contentTextView.value.count) 文字"
    }
    var api:FetchPostProtocol!
    var userAPI:FetchUserProtocol!
    var user = PublishRelay<User>()
    init(tap:Signal<Void>,openTap:Signal<Void>,pictureTap:Signal<Void>,api:FetchPostProtocol,userAPI:FetchUserProtocol) {
        self.api = api
        tap.emit(onNext: { _ in
            self.didTapDismissButton()
        }).disposed(by: disposeBag)
        
        openTap.emit(onNext: { _ in
            self.didTapPostButton()
        }).disposed(by: disposeBag)
        
        pictureTap.emit(onNext:{ _ in
            self.didTapPictureButton()
        }).disposed(by: disposeBag)
        
        self.userAPI = userAPI
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userAPI.fetchUser(userId: uid).subscribe(onSuccess: { user in
            self.user.accept(user)
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposeBag)

    }
    private func didTapDismissButton() {
        print(#function)
        outputs.doneDismiss.accept(())
    }
    private func didTapPostButton() {
        print(#function)
        outputs.donePost.accept(())
    }
    private func didTapPictureButton() {
        print(#function)
        outputs.toPhotoLibrary.accept(())
    }
    func post(image:UIImage,completion:@escaping(Result<String,Error>)->Void) {
       let title = titleTextField.value
       let content = contentTextView.value
        StorageService.upload(image: image) { result in
            switch result {
            case .success(let urlstring):
                self.user.subscribe(onNext: { user in
                    self.api.sendFsData(user:user,title: title, content: content, urlString: urlstring,lat: self.lat,lng: self.lng) { result in
                        switch result {
                        case .success:
                            completion(.success("success"))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }).disposed(by: self.disposeBag)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
