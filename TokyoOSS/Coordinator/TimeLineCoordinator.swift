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
            print("あああ")
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController else { return }
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                vc.present(nav, animated: true, completion: nil)
            }
        case .push:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailController") as? PostDetailController else { return }
            navigationController?.pushViewController(vc, animated: true)
        case .pop:
            print("pop")
        }
    }
    
    
}
