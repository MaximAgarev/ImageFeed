import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageDidChange")
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = makeRequest(username: username, token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let avatarURL = body.profileImage.medium
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    private func makeRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/users"
            + "/\(username)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
