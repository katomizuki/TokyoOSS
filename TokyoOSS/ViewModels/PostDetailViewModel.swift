import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol PostDetailViewModelInputs {
    func didTapLike()
}
protocol PostDetailViewModelOutputs {
    var isLiked:BehaviorRelay<Bool> { get }
    var currentImage:UIImage? { get }
}
protocol PostDetailViewModelType {
    var inputs:PostDetailViewModelInputs { get }
    var outputs:PostDetailViewModelOutputs { get }
}
final class PostDetailViewModel:PostDetailViewModelInputs,PostDetailViewModelOutputs,PostDetailViewModelType {
    var currentImage: UIImage? = UIImage(systemName: "heart")
    var isLiked = BehaviorRelay<Bool>(value: false)
    var inputs: PostDetailViewModelInputs { return self }
    
    var outputs: PostDetailViewModelOutputs { return self }
    func didTapLike() {
        var value = isLiked.value
        value = !value
        isLiked.accept(value)
        currentImage = value ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
}
