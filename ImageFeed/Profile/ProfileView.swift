import UIKit
import Kingfisher


protocol ProfileViewProtocol: AnyObject {
    var viewController: ProfileViewControllerProtocol? { get set }
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfileDetails(profile: Profile)
    func updateAvatar(url: URL)
}

final class ProfileView: UIView, ProfileViewProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    var presenter: ProfilePresenterProtocol?
    
    private lazy var userImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let userImage = UIImageView(image: placeholder)
        return userImage
    }()
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Екатерина Новикова"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        usernameLabel.textColor = .ypWhite
        return usernameLabel
    }()
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGray
        return loginLabel
    }()
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        statusLabel.textColor = .ypWhite
        return statusLabel
    }()
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "ExitButtonImage")!,
            target: self,
            action: #selector(didTapButton))
        logoutButton.tintColor = .ypRed
        logoutButton.accessibilityIdentifier = "LogoutButton"
        return logoutButton
    }()
    
    init(frame: CGRect, viewController: ProfileViewControllerProtocol) {
        super.init(frame: frame)
        self.backgroundColor = .ypBlack
        self.addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addUserImage() {
        self.addSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
//        userImage.layer.cornerRadius = 35
        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 76),
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }
    
    private func addUsernameLabel() {
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor).isActive = true
    }
    
    private func addLoginLabel() {
        self.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
    }
    
    private func addStatusLabel() {
        self.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
    }
    
    private func addLogoutButton() {
        self.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
    }
    
    func addSubviews() {
        addUserImage()
        addUsernameLabel()
        addLoginLabel()
        addStatusLabel()
        addLogoutButton()
    }
    
    func updateProfileDetails(profile: Profile) {
        self.usernameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.statusLabel.text = profile.bio
    }
    
    func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        userImage.kf.setImage(with: url, placeholder: UIImage(named: "UserImagePlaceholder"), options: [.processor(processor)])
    }
    
    @objc
    private func didTapButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2Service.clean()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid configuration")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        viewController?.showExitAlert(alert: alert)
    }
    
}
