
import UIKit

// MARK: - UIContentConfiguration

struct GitConfiguration: UIContentConfiguration, Hashable {
    var image: UIImage?
    var title: String?
    var subtitle: String?

    func makeContentView() -> UIView & UIContentView {
        AvatarContentView(with: self)
    }
    
    func updated(for state: UIConfigurationState) -> GitConfiguration {
        self
    }
}

// MARK: - UIContentView

final class AvatarContentView: UIView, UIContentView {
    private var currentConfiguration: GitConfiguration
    
    var configuration: UIContentConfiguration {
        get { currentConfiguration }
        set {
            guard let configuration = newValue as? GitConfiguration else { return }
            updateConfiguration(with: configuration)
        }
    }
    
    private lazy var loginLabel: UILabel = .init().style(.body).layout(lines: .zero)
    private lazy var githubLabel: UILabel = .init().style(.footnote).layout(lines: .zero)
    private lazy var imageView: UIImageView = makeImageView()
    
    init(with configuration: GitConfiguration) {
        self.currentConfiguration = configuration
        super.init(frame: .zero)
        configureUI()
        updateConfiguration(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Extract magic numbers into constants and correctly fix sizing
    private func configureUI() {
        backgroundColor = .lightGray.withAlphaComponent(Constants.backgroundAlpha)
        
        let textStackView = UIStackView()
            .containing([loginLabel, githubLabel])
            .configured(axis: .vertical, alignment: .firstBaseline)
            .with(margins: Constants.margins, spacing: Constants.spacing)
        let outerStackView = UIStackView()
            .containing([imageView, textStackView])
            .configured(axis: .horizontal)
            .with(margins: Constants.margins, spacing:Constants.spacing)
        addSubview(outerStackView)
        outerStackView.autoPinEdgesToSuperviewEdges()
        NSLayoutConstraint.autoSetPriority(.defaultLow) {
            imageView.autoSetDimensions(to: .init(width: Constants.imageViewHeight, height: Constants.imageViewHeight))
            outerStackView.autoSetDimension(.height, toSize: Constants.cellHeight)
        }
    }
    
    private func updateConfiguration(with configuration: GitConfiguration) {
        guard currentConfiguration != configuration else { return }
        loginLabel.text = configuration.title
        githubLabel.text = configuration.subtitle
        imageView.image = configuration.image
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.imageViewHeight / 2
        return imageView
    }
}

// MARK: - Constants

private extension AvatarContentView {
    enum Constants {
        static let imageViewHeight: CGFloat = 90
        static let cellHeight: CGFloat = 100
        static let margins: UIEdgeInsets = .uniform(8)
        static let spacing: CGFloat = 8.0
        static let backgroundAlpha: CGFloat = 0.2
    }
}

// MARK: - UICollectionViewListCell

final class AvatarCell: UICollectionViewListCell {
    private var configuration: GitConfiguration
    
    init(configuration: GitConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        let newConfiguration = configuration.updated(for: state)
        contentConfiguration = newConfiguration
    }

}
