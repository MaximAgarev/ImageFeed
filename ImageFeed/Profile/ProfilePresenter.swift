import Foundation

protocol ProfilePresenterProtocol {
    var viewController: ProfileViewControllerProtocol? { get set }
    var view: ProfileViewProtocol? { get set }
    
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var viewController: ProfileViewControllerProtocol?
    weak var view: ProfileViewProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {

        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
        
        if let profileImageURL = profileImageService.avatarURL,
           let url = URL(string: profileImageURL) {
            view?.updateAvatar(url: url)
            
            
            profileImageServiceObserver = NotificationCenter.default.addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.view?.updateAvatar(url: url)
                    
                }
            )}
        
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewController: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    var view: ProfileViewProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
}
