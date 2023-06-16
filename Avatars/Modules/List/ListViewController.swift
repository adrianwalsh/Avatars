import UIKit

class ListViewController: UICollectionViewController {
    
    private lazy var viewModel: ListViewModelType = ListViewModel(collectionView: collectionView.register(cell: AvatarCell.self))
    
    init() {
        super.init(collectionViewLayout: .list)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchGitHubUsers()
    }
}

extension ListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.pushDetailController(with: navigationController, at: indexPath)
    }
}
