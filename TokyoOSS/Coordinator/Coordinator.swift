import Foundation
import UIKit
enum EventTap {
    case dismiss
    case perform
    case push
    case pop
}
protocol Coordinator {
    func start()
    var navigationController: UINavigationController? { get set }
    func eventOccurred(tap: EventTap,vc:UIViewController)
}
protocol Coordinating {
    var coordinator:Coordinator? { get set }
}
