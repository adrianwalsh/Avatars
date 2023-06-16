import UIKit

extension UIEdgeInsets {
    static func uniform(_ size: CGFloat) -> UIEdgeInsets {
        .init(top: size, left: size, bottom: size, right: size)
    }
}
