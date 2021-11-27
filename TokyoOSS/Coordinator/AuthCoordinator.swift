import Foundation
import UIKit

final class AuthCoordinator:Coordinator {
    var navigationController: UINavigationController?
    func start() {
        
    }
    func eventOccurred(tap: EventTap,vc:UIViewController) {
        switch tap {
        case .dismiss:
            print("dismiss")
        case .perform:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            controller.modalPresentationStyle = .fullScreen
            vc.present(controller, animated: true, completion: nil)
        case .push:
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "RegisterController") as? RegisterController else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        case .pop:
            print("pop")
        }
    }
}
