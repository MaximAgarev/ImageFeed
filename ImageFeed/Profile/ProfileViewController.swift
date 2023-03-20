import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2Service = OAuth2Service.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUserImage()
        addUsernameLabel()
        addLoginLabel()
        addStatusLabel()
        addLogoutButton()
        view.backgroundColor = .ypBlack
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        )
        updateAvatar()
    }
    
    private func addUserImage() {
        view.addSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func addUsernameLabel() {
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor).isActive = true
    }
    
    private func addLoginLabel() {
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
    }
    
    private func addStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
    }
    
    private func addLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
    }
    
    private func updateProfileDetails(profile: Profile) {
        self.usernameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.statusLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: userImage.frame.size.height / 2)
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
        self.present(alert, animated: true)
    }
}
