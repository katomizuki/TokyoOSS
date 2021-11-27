import Foundation
import UIKit
final class MainCoordinator:Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        
    }
    func eventOccurred(tap: EventTap,vc:UIViewController) {
        switch tap {
        case .dismiss:
            vc.dismiss(animated: true, completion: nil)
        case .perform:
            print("perform")
        case .push:
            vc.dismiss(animated: true, completion: nil)
        case .pop:
            print("pop")
        }
    }
}

