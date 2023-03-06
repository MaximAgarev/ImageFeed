import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "token"

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: "Auth token")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
            }
        }
    }
}
