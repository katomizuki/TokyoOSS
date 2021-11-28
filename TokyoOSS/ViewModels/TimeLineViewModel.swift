import Foundation
import RxSwift
import RxCocoa
protocol TimeLineViewModelInputs {
    func didTapCell()
}
protocol TimeLineViewModelOutputs {
    var cellTap:PublishRelay<Void> { get }
}
protocol TimeLineViewModelType {
    var inputs:TimeLineViewModelInputs { get }
    var outputs:TimeLineViewModelOutputs { get }
}
final class TimeLineViewModel:TimeLineViewModelType,TimeLineViewModelInputs,TimeLineViewModelOutputs {
    
    var cellTap = PublishRelay<Void>()
    
    
    var inputs: TimeLineViewModelInputs { return self }
    var outputs: TimeLineViewModelOutputs { return self }
    
    func didTapCell() {
        outputs.cellTap.accept(())
    }
}
