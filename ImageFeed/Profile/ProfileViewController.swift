import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var profileView: ProfileViewProtocol? { get set }
    var profilePresenter: ProfilePresenterProtocol? { get set }

    func showExitAlert(alert: UIAlertController)
    }

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var profileView: ProfileViewProtocol?
    var profilePresenter: ProfilePresenterProtocol? = ProfilePresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let profileView = ProfileView(frame: .zero, viewController: self)
        self.view = profileView
        profileView.viewController = self
        
        profilePresenter?.viewController = self
        profilePresenter?.view = profileView
        
        profilePresenter?.viewDidLoad()
    }
    
    func showExitAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var profileView: ProfileViewProtocol?
    
    var profilePresenter: ProfilePresenterProtocol?
    
    func showExitAlert(alert: UIAlertController) {
    }
    
    
}
