import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var firstLaunch: Bool = true
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var logoImage: UIImageView = {
        let image = UIImage(named: "Vector")
        let logoImage = UIImageView(image: image)
        return logoImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addLogoImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLaunch {
            firstLaunch = false
                        
            if let token = OAuth2TokenStorage().token {
                fetchProfile(token: token)
            } else {
                switchToAuthViewController()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func addLogoImage() {
        view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.centerYAnchor.constraint(equalTo: view
            .safeAreaLayoutGuide.centerYAnchor).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view
            .safeAreaLayoutGuide.centerXAnchor).isActive = true
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid configuration")
            return }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        guard let authViewController = getViewController(with: "AuthViewController") as? AuthViewController
        else {
            assertionFailure("Invalid configuration")
            return
        }
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true)
    }
    
    private func getViewController(with id: String) -> UIViewController {
             
             let storyboard = UIStoryboard(name: "Main", bundle: .main)
             let viewController = storyboard.instantiateViewController(withIdentifier: id)
             return viewController
         }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.presentNetworkErrorAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.presentNetworkErrorAlert()
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            switch result {
            case .success(let avatarURL):
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
            case .failure:
                self.presentNetworkErrorAlert()
            }
        }
    }
    
    private func presentNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
