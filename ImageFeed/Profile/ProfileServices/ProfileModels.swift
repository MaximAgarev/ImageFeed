import Foundation

// MARK: - ProfileService
struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var loginName: String {
        return "@\(username)"
    }
}

// MARK: - ProfileImageService
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let medium: String
}
