import Foundation

let AccessKey = "PS9-83s7sMRJqDYVrRq-2bUpYZhIZ1P3q665bAh3ThM"
let SecretKey = "cc3mVU2hLCNI2MqL-vYX8UDWSBoFT6ff8DH5Y6gZqJY"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: URL,
         unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 unsplashAuthorizeURLString: UnsplashAuthorizeURLString)
    }
}
