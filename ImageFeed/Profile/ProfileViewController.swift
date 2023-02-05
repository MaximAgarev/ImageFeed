import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var userImage: UIImageView = {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        let userImage = UIImageView(image: placeholder)
        return userImage
    }()
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Екатерина Новикова"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        usernameLabel.textColor = UIColor(named: "YP White (iOS)")
        return usernameLabel
    }()
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(named: "YP Gray (iOS)")
        return loginLabel
    }()
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        statusLabel.textColor = UIColor(named: "YP White (iOS)")
        return statusLabel
    }()
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "ExitButtonImage")!,
            target: self,
            action: #selector(didTapButton))
        logoutButton.tintColor = UIColor(named: "YP Red (iOS)")
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserImage()
        addUsernameLabel()
        addLoginLabel()
        addStatusLabel()
        addLogoutButton()
        
    }
    
    func addUserImage() {
        view.addSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalToConstant: 70),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func addUsernameLabel() {
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor).isActive = true
    }
    
    func addLoginLabel() {
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
    }
    
    func addStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
    }
    
    func addLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
    }
    
    @objc
    func didTapButton() {
        
    }
    
}
