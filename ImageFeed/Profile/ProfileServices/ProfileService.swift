import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
                
        let request = makeRequest(token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.username, firstName: body.firstName ?? "", lastName: body.lastName ?? "", bio: body.bio ?? "")
                        self.profile = profile
                        completion(.success(profile))
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

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
