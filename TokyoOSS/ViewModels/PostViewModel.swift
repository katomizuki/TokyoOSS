import Foundation
import RxSwift
import RxCocoa
import RxDataSources
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
}
protocol PostViewModelType {
    var inputs:PostViewModelInputs { get }
    var outputs:PostViewModelOutputs { get }
}
final class PostViewModel:PostViewModelType,PostViewModelInputs,PostViewModelOutputs {
    
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
    init(tap:Signal<Void>,openTap:Signal<Void>,pictureTap:Signal<Void>,api:FetchPostProtocol) {
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
                self.api.sendFsData(title: title, content: content, urlString: urlstring) { result in
                    switch result {
                    case .success:
                        completion(.success("success"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
