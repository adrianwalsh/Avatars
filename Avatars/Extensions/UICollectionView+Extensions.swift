import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) -> Self {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        return self
    }
}
