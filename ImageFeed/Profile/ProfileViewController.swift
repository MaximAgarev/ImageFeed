import UIKit

final class ProfileViewController: UIViewController {
    
    private var userImage: UIImageView!
    private var usernameLabel: UILabel!
    private var loginLabel: UILabel!
    private var statusLabel: UILabel!
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserImage()
        addUsernameLabel()
        addLoginLabel()
        addStatusLabel()
        addLogoutButton()
        
    }
    
    func addUserImage() {
        let placeholder = UIImage(named: "UserImagePlaceholder")
        userImage = UIImageView(image: placeholder)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImage)
        NSLayoutConstraint.activate([
        userImage.heightAnchor.constraint(equalToConstant: 70),
        userImage.widthAnchor.constraint(equalToConstant: 70),
        userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
        userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func addUsernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.text = "Екатерина Новикова"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        usernameLabel.textColor = UIColor(named: "YP White (iOS)")
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor).isActive = true
    }
    
    func addLoginLabel() {
        loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(named: "YP Gray (iOS)")
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
    }
    
    func addStatusLabel() {
        statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        statusLabel.textColor = UIColor(named: "YP White (iOS)")
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
    }
    
    func addLogoutButton() {
        logoutButton = UIButton.systemButton(
            with: UIImage(named: "ExitButtonImage")!,
            target: self,
            action: #selector(self.didTapButton))
        logoutButton.tintColor = UIColor(named: "YP Red (iOS)")
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    func didTapButton() {

    }
    
}
