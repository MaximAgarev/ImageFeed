import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private var photosTask: URLSessionTask?
    private var likeTask: URLSessionTask?

    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?

    func fetchPhotosNextPage() {
        guard photosTask == nil else { return }
        
        var nextPage: Int
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        self.lastLoadedPage = nextPage

        assert(Thread.isMainThread)
        photosTask?.cancel()

        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = makeRequest(page: nextPage, token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async() {
                switch result {
                case .success(let photoResults):
                    photoResults.forEach { photoResult in
                        let photo = self.getPhoto(photoResult)
                        if !self.photos.contains(photo) {
                            self.photos.append(photo)
                        }
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                    self.photosTask = nil
                case .failure(let error):
                    assertionFailure("\(error)")
                }
            }
        }
        self.photosTask = task
        task.resume()
        
    }
    
    func getPhoto(_ photoResult: PhotoResult) -> Photo {
        let photo = Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
        return photo
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        likeTask?.cancel()
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = makeLikeRequest(photoId: photoId, isLike: isLike, token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) -> Void in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.switchLike(result: result, photoId: photoId, completion: completion)
                    completion(.success(()))
                    self.likeTask = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.likeTask = task
        task.resume()
    }
    
    func switchLike(result: Result<LikeResult, Error>, photoId: String, completion: @escaping (Result<Void, Error>) -> Void){
        switch result {
        case .success:
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.photos[index]
                let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
                self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)}
        case .failure(let error):
            assertionFailure("\(error)")
        }
    }
}

extension ImagesListService {
    private func makeRequest(page: Int,  token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)",
            httpMethod: "GET",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeLikeRequest(photoId: String, isLike: Bool, token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "DELETE" : "POST",
            baseURL: DefaultBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
