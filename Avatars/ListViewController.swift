
import UIKit

class ListViewController: UICollectionViewController {

    private let networkService = NetworkService()

    private var githubUsers = [GitUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkService.get(url: .githubUsersEndpoint, resultType: [GitUser].self) { result in
            switch result {
            case .failure:
                self.githubUsers = []
            case .success(let users):
                self.githubUsers = users
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return githubUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: AvatarCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AvatarCell
        cell.networkService = networkService
        cell.githubUser = githubUsers[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? AvatarCell, let githubUser = cell.githubUser else { return }
        guard let profileViewController = segue.destination as? DetailsViewController else { return }

        profileViewController.networkService = networkService
        profileViewController.github = githubUser
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    private var insets: UIEdgeInsets { UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0) }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 2 * insets.left, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}
