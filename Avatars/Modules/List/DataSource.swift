import UIKit

final class DiffableDataSource: UICollectionViewDiffableDataSource<ListViewModel.Section, GitUser> {
    private let registration: UICollectionView.CellRegistration<UICollectionViewListCell, GitUser>
    
    init(collectionView: UICollectionView, registration: UICollectionView.CellRegistration<UICollectionViewListCell, GitUser>) {
        self.registration = registration
        super.init(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
}
