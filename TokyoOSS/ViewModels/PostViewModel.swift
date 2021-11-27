import Foundation
import RxSwift
import RxCocoa
protocol PostViewModelInputs {
    
}
protocol PostViewModelOutputs {
    var doneDismiss:PublishRelay<Void> { get }
    var donePost:PublishRelay<Void> { get }
}
protocol PostViewModelType {
    var inputs:PostViewModelInputs { get }
    var outputs:PostViewModelOutputs { get }
}
final class PostViewModel:PostViewModelType,PostViewModelInputs,PostViewModelOutputs {
    
    var inputs: PostViewModelInputs { return self }
    var outputs: PostViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    var doneDismiss = PublishRelay<Void>()
    var donePost = PublishRelay<Void>()
    init(tap:Signal<Void>,openTap:Signal<Void>) {
        tap.emit(onNext: { _ in
            self.didTapDismissButton()
        }).disposed(by: disposeBag)
        
        openTap.emit(onNext: { _ in
            self.didTapPostButton()
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
}
