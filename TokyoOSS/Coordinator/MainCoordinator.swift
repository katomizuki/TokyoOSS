import Foundation
import UIKit
final class MainCoordinator:Coordinator {
    var navigationController: UINavigationController?
    private let picker = UIImagePickerController()
    func start() {
        
    }
    func eventOccurred(tap: EventTap,vc:UIViewController) {
        switch tap {
        case .dismiss:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            vc.dismiss(animated: true, completion: nil)
         })
        case .perform:
            print("perform")
        case .push:
            vc.dismiss(animated: true, completion: nil)
        case .pop:
            print("pop")
        }
    }
}

