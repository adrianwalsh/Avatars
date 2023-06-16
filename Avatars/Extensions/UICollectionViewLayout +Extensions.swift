import UIKit

extension UICollectionViewLayout {
    
    static let list: UICollectionViewCompositionalLayout = {
        .list(using: .init(appearance: .plain))
    }()
}
