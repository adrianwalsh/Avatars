
import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!

    var login: String? {
        get {
            loginLabel.text
        }
        set {
            loginLabel.text = newValue
        }
    }

    var github: String? {
        get {
            githubLabel.text
        }
        set {
            githubLabel.text = "GitHub: \(newValue ?? "N/A")"
        }
    }

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    var githubUser: GitUser? {
        didSet {
            login = githubUser?.login
            github = githubUser?.html_url

            guard let url = githubUser?.avatar_url else { return }

            activityIndicator.startAnimating()

            networkService?.get(url: url) { result in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()

                    switch result {
                    case .success(let data):
                        self.imageView.image = UIImage(data: data)
                    case .failure:
                        break
                    }
                }
            }
        }
    }

    var networkService: NetworkService?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 5.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
    }
}
