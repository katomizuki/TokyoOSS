import Foundation
import UIKit

final class TimeLineCoordinator:Coordinator {
    func start() {
    }
    
    var navigationController: UINavigationController?
    
    func eventOccurred(tap: EventTap, vc: UIViewController) {
        switch tap {
        case .dismiss:
            print("dismiss")
        case .perform:
            print("perform")
        case .push:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailController") as? PostDetailController else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .pop:
            print("pop")
        }
    }
    
    
}
