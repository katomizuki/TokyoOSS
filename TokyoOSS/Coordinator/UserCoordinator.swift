import Foundation
import UIKit

final class UserCoordinator:Coordinator {
    func start() {
        
    }
    
    var navigationController: UINavigationController?
    
    func eventOccurred(tap: EventTap, vc: UIViewController) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       guard let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailController") as? PostDetailController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
