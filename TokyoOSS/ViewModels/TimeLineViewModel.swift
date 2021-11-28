import Foundation
import RxSwift
import RxCocoa
protocol TimeLineViewModelInputs {
    func didTapCell()
    func didTapLikeButton()
}
protocol TimeLineViewModelOutputs {
    var cellTap:PublishRelay<Void> { get }
    var isError:BehaviorRelay<Bool> { get }
    var timeLineList:BehaviorRelay<[Post]> { get }
    var likeButtonTap:PublishRelay<Void> { get }
    var isLike:Bool { get }
    var currentImage:UIImage { get }
}
protocol TimeLineViewModelType {
    var inputs:TimeLineViewModelInputs { get }
    var outputs:TimeLineViewModelOutputs { get }
}
final class TimeLineViewModel:TimeLineViewModelType,TimeLineViewModelInputs,TimeLineViewModelOutputs {
    var currentImage: UIImage = UIImage(systemName: "heart")!
    var cellTap = PublishRelay<Void>()
    var inputs: TimeLineViewModelInputs { return self }
    var outputs: TimeLineViewModelOutputs { return self }
    var isError = BehaviorRelay<Bool>(value: false)
    var postAPI:FetchPostProtocol!
    private let disposeBag = DisposeBag()
    var timeLineList = BehaviorRelay<[Post]>(value: [])
    var likeButtonTap = PublishRelay<Void>()
    var isLike = false
    init(postAPI:FetchPostProtocol) {
        self.postAPI = postAPI
    }
    func didTapCell() {
        outputs.cellTap.accept(())
    }
    func showTimeLine() {
        print(#function)
        postAPI.getFsData().subscribe(onSuccess: { [weak self] posts in
            self?.timeLineList.accept(posts)
        }, onFailure: { [weak self] _ in
            self?.isError.accept(true)
        }).disposed(by: disposeBag)
    }
    func didTapLikeButton() {
        print(#function)
        outputs.likeButtonTap.accept(())
        isLike.toggle()
        print(isLike)
        if isLike {
            currentImage = UIImage(systemName: "heart.fill")!
        } else {
            currentImage = UIImage(systemName: "heart")!
        }
    }
}
