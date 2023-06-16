import UIKit

protocol ListViewModelType: AnyObject {
    func fetchGitHubUsers()
    func pushDetailController(with navigationController: UINavigationController?, at indexPath: IndexPath)
}

final class ListViewModel: NSObject {
    
    enum Section {
        case initial
    }
    
    private let networkService: NetworkServiceType
    
    private let downloader: AvatarDownloader
    
    private unowned var collectionView: UICollectionView
    
    private(set) lazy var dataSource = DiffableDataSource(collectionView: collectionView, registration: makeRegistration())
    
    init(networkService: NetworkServiceType = NetworkService(),
         downloader: AvatarDownloader = AvatarDownloader(),
         collectionView: UICollectionView) {
        self.networkService = networkService
        self.downloader = downloader
        self.collectionView = collectionView
        super.init()
    }
    
    private func configureDataSource(with users: [GitUser]) {
        DispatchQueue.main.async { [self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, GitUser>()
            snapshot.appendSections([.initial])
            snapshot.appendItems(users)
            dataSource.apply(snapshot)
        }
    }
    
    private func updateDataSource(with users: [GitUser]) {
        DispatchQueue.main.async { [self] in
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            snapshot.appendItems(users)
            dataSource.apply(snapshot)
        }
    }
    
    private func makeRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, GitUser> {
        {
            UICollectionView.CellRegistration<UICollectionViewListCell, GitUser> { [unowned self] (cell, indexPath, user) in
                var configuration = GitConfiguration()
                // This downloader class needs caching quite badly. No scope to refactor in this PR
                downloader.downloadAvatar(avatarID: user.avatar_url, size: 90) {
                    switch $0 {
                    case .success(let image):
                        configuration.image = image
                        configuration.title = user.login
                        configuration.subtitle = user.html_url
                        DispatchQueue.main.async {
                            cell.contentConfiguration = configuration
                        }
                    case .failure(let error):
                        // TODO: Handle error
                        print(error)
                    }
                }
                cell.contentConfiguration = configuration
            }
        }()
    }
}

// MARK: - ListViewModelType

extension ListViewModel: ListViewModelType {
    
    func fetchGitHubUsers() {
        networkService.get(url: .githubUsersEndpoint, resultType: [GitUser].self) { [weak self] result in
            switch result {
            case .failure:
                self?.updateDataSource(with: [])
            case .success(let users):
                self?.configureDataSource(with: users)
            }
        }
    }
    
    // This is not my recommended appproach. I would use MVVM-C so the Coordinator would be responsible for navigation.
    // I would also remove storyboard for detail controller to achieve proper dependency injection
    
    func pushDetailController(with navigationController: UINavigationController?, at indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailController = storyBoard.instantiateViewController(identifier: "AvatarDetailController") as? DetailsViewController,
            let networkService = networkService as? NetworkService else { return }
        detailController.networkService = networkService
        detailController.github = dataSource.itemIdentifier(for: indexPath)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
