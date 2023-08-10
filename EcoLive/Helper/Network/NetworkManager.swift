//
//  NetworkManager.swift
//  Currency Converter
//
//  Created by Amit Shukla on 22/12/17.
//  Copyright © 2017 Amit Shukla. All rights reserved.
//

import Foundation
import Alamofire



import UIKit
import SystemConfiguration

public class ReachabilityCheck {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
  


let isDebug = true

public class SSFiles {
    var url: URL?
    var image: UIImage?
    var name: String = "File"
    var paramKey: String = "file"
 
    
    var isVideo = false
    var thumbImage: UIImage?
    
    init(url: URL, thumbImage: UIImage) {
        self.url = url
        name = (url.absoluteString as NSString).lastPathComponent
        isVideo = true
        self.thumbImage = thumbImage
    }
    
    init(url: URL, paramKey: String) {
        self.url = url
        self.paramKey = paramKey
        name = (url.absoluteString as NSString).lastPathComponent
    }
    
    init(image: UIImage, paramKey: String) {
        self.image = image
        self.paramKey = paramKey
        name = "image"
    }
    
    
    init(image: UIImage, thumbImage: UIImage, paramKey: String = "file") {
        self.image = image
        name = "image"
        isVideo = false
        self.paramKey = paramKey
        self.thumbImage = thumbImage
    }
     
}

class MultipartImage {
     
    var image:UIImage!
    var keyName: String = "File"
    var fileName: String = "File"
     
    init(image: UIImage, keyName: String, fileName: String) {
        self.image = image
        self.keyName = keyName
        self.fileName = fileName
    }
}
var NO_INTERNET_MESSAGE = "You’ve been away from the app for some time. Please refresh the home screen and check your internet connection."

class NetworkManagerChat {
    
//    static let PROTOCOL:String = "http://";
//    static let SUB_DOMAIN:String =  "testapi.";
//    static let DOMAIN:String = "newdevpoint.in/";
//    static let API_DIR:String = "api/";
//    static let SITE_URL = PROTOCOL + SUB_DOMAIN + DOMAIN;
//    static let URL_FILE_UPLOAD = "\(SITE_URL)upload"
    
    // http://testapi.newdevpoint.in/upload
    
    
//https://nightout.ezxdemo.com/api/upload_chat_file
    
    static let PROTOCOL:String = "https://";
    static let SUB_DOMAIN:String =  "nightout.";
    static let DOMAIN:String = "ezxdemo.com/";
    static let API_DIR:String = "api/";
    static let SITE_URL = PROTOCOL + SUB_DOMAIN + DOMAIN + API_DIR;
    static let URL_FILE_UPLOAD = "\(SITE_URL)upload_chat_file"

    
}

class NetworkManager {

//https://api.ecolive.global/api/
    //http://fahemni.herokuapp.com/admin
    static let PROTOCOL:String = "https://";
    static let SUB_DOMAIN:String = "";
    static let DOMAIN:String = "api.ecolive.global/";
    static let API_DIR:String = "api1/";

    static let SITE_URL = PROTOCOL + SUB_DOMAIN + DOMAIN;
    static let SITE_URL_CHAT = NetworkManagerChat.PROTOCOL + NetworkManagerChat.SUB_DOMAIN + NetworkManagerChat.DOMAIN;
    static let API_URL = SITE_URL + API_DIR;
    static let New_API_DIR:String = SITE_URL + "api1/";

//    static let STORAGE_URL = SITE_URL + "uploads/";
    
    //-------------
    static let URL_FILE_UPLOAD = "\(SITE_URL)upload"
    //    static let URL_FILE_UPLOAD = "http://127.0.0.1:8000/?url=upload"
    
    static let URL_WEB_SOCKET = "ws://sschat-react.herokuapp.com/V1"
    //    static let URL_WEB_SOCKET = "ws://172.16.16.231:1337/V1"
    
    
    static let IMAGE_BASE_URL = "https://nightout.ezxdemo.com/storage/"
    static let DEFAULT_IMAGE_PATH = "https://nightout.ezxdemo.com/admin/images/1.png";
    static let STORAGE_URL =  "https://d25r90pnce3cxs.cloudfront.net/uploads/";
    
//    static let BODYGROUP = "bodygroup/";
//    static let EXERCISES = "exercises/";
//    static let CHALLENGES = "challenges/";
//    static let PROFILE = "user/";
     
    static let PRIVACY_POLICY_URL = "\(SITE_URL)privacy-policy"
    static let TERMS_AND_CONDITIONS = "\(SITE_URL)"
    static let FAQ = "\(SITE_URL)faq"
    
    //-------------
    

   static func convertToDictionary(text: String?) -> [String: Any]? {
        if (text == nil) {return nil};
        if let data = text!.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func logout(){
        //LoginUserModel.shared.logout()
//        let nav1 = UINavigationController()
//        nav1.isNavigationBarHidden = true
        //let vc = LoginViewController()
//        nav1.viewControllers = [vc]
//        UIApplication.shared.windows.first?.rootViewController = nav1
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
     
    static func convertStatus(value: String?, defaultErrorMessage: String, isSuccess: Bool) -> NetworkResponseState {
        if let responseData = NetworkManager.convertToDictionary(text: value) {
            if(isSuccess){
                return .success(responseData)
            }else{
                return .failed(.serverError(responseData["message"] as? String ?? defaultErrorMessage))
            }
        } else {
            return .failed(.serverError(defaultErrorMessage))
        }
    }
    
    static func parseResponse(response: AFDataResponse<String>, completion: @escaping (NetworkResponseState) -> Void) {
        
        var ermessage:String?
        if let erResponseData = NetworkManager.convertToDictionary(text: response.value?.string){
            ermessage = erResponseData["message"] as? String
            if let message = erResponseData["message"] as? NSDictionary {
                ermessage = message.getApiErrorMessage()
            }
            
        }
        switch(HTTPStatusCode(rawValue: response.response?.statusCode ?? 500)){
        case .ok:
            completion(convertStatus(value: response.value?.string, defaultErrorMessage: ermessage ??  "Server side error occured.", isSuccess: true))
            break
        case .continue:
            completion(convertStatus(value: response.value?.string, defaultErrorMessage:  ermessage ?? "Continue", isSuccess: false))
        case .switchingProtocols:
            completion(.failed(.serverError( ermessage ?? "Switching Protocols")))
        case .processing:
            completion(.failed(.serverError( ermessage ?? "Processing")))
        case .created:
            completion(convertStatus(value: response.value?.string, defaultErrorMessage:  ermessage ?? "Created", isSuccess: true))
        case .accepted:
            completion(.failed(.serverError( ermessage ?? "Accepted")))
        case .nonAuthoritativeInformation:
//                    completion(.failed("Non Authoritative Information"))
            completion(convertStatus(value: response.value?.string, defaultErrorMessage:  ermessage ?? "This is not your content", isSuccess: false))
        case .noContent:
            completion(convertStatus(value: response.value?.string, defaultErrorMessage:  ermessage ?? "No Content Found", isSuccess: true))
        case .resetContent:
            completion(.failed(.serverError( ermessage ?? "Reset Content")))
        case .partialContent:
            completion(.failed(.serverError( ermessage ?? "Partial Content")))
        case .multiStatus:
            completion(.failed(.serverError( ermessage ?? "Multi Status")))
        case .alreadyReported:
            completion(.failed(.serverError( ermessage ?? "Already Reported")))
        case .IMUsed:
            completion(.failed(.serverError( ermessage ?? "IM Used")))
        case .multipleChoices:
            completion(.failed(.serverError( ermessage ?? "Multiple Choices")))
        case .movedPermanently:
            completion(.failed(.serverError( ermessage ?? "Moved Permanently")))
        case .found:
            completion(.failed(.serverError( ermessage ?? "Found")))
        case .seeOther:
            completion(.failed(.serverError( ermessage ?? "See Other")))
        case .notModified:
            completion(.failed(.serverError( ermessage ?? "Not Modified")))
        case .useProxy:
            completion(.failed(.serverError( ermessage ?? "Use Proxy")))
        case .switchProxy:
            completion(.failed(.serverError( ermessage ?? "Switch Proxy")))
        case .temporaryRedirect:
            completion(.failed(.serverError( ermessage ?? "Temporary Redirect")))
        case .permenantRedirect:
//                    completion(.failed("Permenant Redirect"))
            completion(convertStatus(value: response.value?.string, defaultErrorMessage:  ermessage ?? "This app needs to be updated", isSuccess: false))
        case .badRequest:
            completion(.failed(.serverError( ermessage ?? "Bad Request")))
        case .unauthorized:
            if let responseData = NetworkManager.convertToDictionary(text: response.value?.string) {
                completion(.failed(.logout(responseData["message"] as? String  ?? "Your session expired. Please login again")))
            }else{
                completion(.failed(.logout( ermessage ?? "Your session expired. Please login again")))
            }
            
            // Note : Remove Save local Data and go to Login Page
            NetworkManager.clearLocaldataGotoLogin(gotoLogin: false);

            
        case .paymentRequired:
            completion(.failed(.serverError( ermessage ?? "Payment Required")))
        case .forbidden:
            completion(.failed(.serverError( ermessage ?? "For bidden")))
        case .notFound:
            completion(.failed(.serverError( ermessage ?? "Not Found")))
        case .methodNotAllowed:
            completion(.failed(.serverError( ermessage ?? "Method Not Allowed")))
        case .notAcceptable:
            completion(.failed(.serverError( ermessage ?? "Not Acceptable")))
        case .proxyAuthenticationRequired:
            completion(.failed(.serverError( ermessage ?? "Proxy Authentication Required")))
        case .requestTimeout:
            completion(.failed(.serverError( ermessage ?? "Request Timeout")))
        case .conflict:
            completion(.failed(.serverError(ermessage  ?? "Conflicts")))
        case .gone:
            completion(.failed(.serverError( ermessage ?? "Gone")))
        case .lengthRequired:
            completion(.failed(.serverError( ermessage ?? "Length Requireds")))
        case .preconditionFailed:
            completion(.failed(.serverError( ermessage ?? "Precondition Failed")))
        case .payloadTooLarge:
            completion(.failed(.serverError( ermessage ?? "Payload Too Large")))
        case .URITooLong:
            completion(.failed(.serverError( ermessage ?? "URI Too Longs")))
        case .unsupportedMediaType:
            completion(.failed(.serverError( ermessage ?? "Unsupported Media Type")))
        case .rangeNotSatisfiable:
            completion(.failed(.serverError( ermessage ?? "Range Not Satisfiable")))
        case .expectationFailed:
            completion(.failed(.serverError( ermessage ?? "Expectation Failed")))
        case .teapot:
            completion(.failed(.serverError( ermessage ?? "Teapot")))
        case .misdirectedRequest:
            completion(.failed(.serverError( ermessage ?? "Misdirected Request")))
        case .unprocessableEntity:
            completion(.failed(.serverError( ermessage ?? "Unprocessable Entity")))
        case .locked:
            completion(.failed(.serverError( ermessage ?? "Locked")))
        case .failedDependency:
            completion(.failed(.serverError( ermessage ?? "Failed Dependency")))
        case .upgradeRequired:
            completion(.failed(.serverError( ermessage ?? "Upgrade Required")))
        case .preconditionRequired:
            completion(.failed(.serverError( ermessage ?? "Precondition Required")))
        case .tooManyRequests:
            completion(.failed(.serverError( ermessage ?? "Too Many Requests")))
        case .requestHeaderFieldsTooLarge:
            completion(.failed(.serverError( ermessage ?? "Request Header Fields Too Large")))
        case .noResponse:
            completion(.failed(.serverError( ermessage ?? "No Response")))
        case .unavailableForLegalReasons:
            completion(.failed(.serverError( ermessage ?? "Unavailable For Legal Reasons")))
        case .SSLCertificateError:
            completion(.failed(.serverError( ermessage ?? "SSL Certificate Error")))
        case .SSLCertificateRequired:
            completion(.failed(.serverError( ermessage ?? "SSL Certificate Required")))
        case .HTTPRequestSentToHTTPSPort:
            completion(.failed(.serverError( ermessage ?? "HTTP Request Sent To HTTPS Ports")))
        case .clientClosedRequest:
            completion(.failed(.serverError( ermessage ?? "Client Closed Request")))
        case .internalServerError:
            completion(.failed(.serverError( ermessage ?? "Internal Server Error")))
        case .notImplemented:
            completion(.failed(.serverError( ermessage ?? "Not Implemented")))
        case .badGateway:
            completion(.failed(.serverError( ermessage ?? "Bad Gateway")))
        case .serviceUnavailable:
            completion(.failed(.serverError( ermessage ?? "Service Unavailable")))
        case .gatewayTimeout:
            completion(.failed(.serverError( ermessage ?? "Gateway Timeout")))
        case .HTTPVersionNotSupported:
            completion(.failed(.serverError( ermessage ?? "HTTP Version Not Supported")))
        case .variantAlsoNegotiates:
            completion(.failed(.serverError( ermessage ?? "Variant Also Negotiates")))
        case .insufficientStorage:
            completion(.failed(.serverError( ermessage ?? "Insufficient Storage")))
        case .loopDetected:
            completion(.failed(.serverError( ermessage ?? "Loop Detected")))
        case .notExtended:
            completion(.failed(.serverError( ermessage ?? "Not Extended")))
        case .networkAuthenticationRequired:
            completion(.failed(.serverError( ermessage ?? "Network Authentication Required")))
        case .none:
            completion(.failed(.serverError( ermessage ?? "Unknow Error")))
        }
    }
//https://api.ecolive.global/api1/introduction-page-list
//https://api.ecolive.global/server/api1/introduction-page-list
    static func callService(url:String, parameters:Parameters, httpMethod:HTTPMethod = .post, header: HTTPHeaders = [:], completion: @escaping (NetworkResponseState) -> Void){
        if ReachabilityCheck.isConnectedToNetwork() == false{
            completion(.failed(.noInternet("You’ve been away from the app for some time. Please refresh the home screen and check your internet connection.")))
            return
        } else {
            var tokenDict: HTTPHeaders = header
            //        if LoginUserModel.shared.isLogin {
            if defaults.object(forKey: kAuthToken) != nil {
                tokenDict["Content-Type"] = "application/json"
                tokenDict["Authorization"] = "Bearer \(defaults.object(forKey: kAuthToken) as! String)"
//                headers = [
//                    "Authorization": "Bearer \(defaults.object(forKey: kAuthToken) as! String)",
//                ]
            }else{
                tokenDict = ["Content-Type": "application/json" ]
            }

            AF.request(url, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseString { response in
                print("Request Parameters: \(String(describing: parameters))")   // original url request
                print("Request Url : \(String(describing: response.request?.url))")   // original url request
//                print("Response api: \(String(describing: response.response))")
//                print("response Value : \(String(describing: response.value))")// http url response
                if let jsonData = response.value?.data(using: .utf8) {
                    do {
                        let jsonString = response.result
                        print("Result jsonString = \(jsonString)")
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        print("Result json : \(json)")
                    }catch(let error){
                        print("error : \(error)")
                    }
                }
                NetworkManager.parseResponse(response: response, completion: completion)
                }
            }
        
    }
    
    
    
    static func callServiceGet(url:String, parameters: [String:Any]?, httpMethod:HTTPMethod = .get, header: HTTPHeaders = [:], completion: @escaping (NetworkResponseState) -> Void){
        if ReachabilityCheck.isConnectedToNetwork() == false{
            completion(.failed(.noInternet(NO_INTERNET_MESSAGE)))
            return
        } else {
            var tokenDict: HTTPHeaders = header
//                    if LoginUserModel.shared.isLogin {
            if (defaults.value(forKey: kAuthToken) as? String) != "" {
                tokenDict["Content-Type"] = "application/json"
                tokenDict["Authorization"] = "Bearer \(defaults.value(forKey: kAuthToken) ?? "")"

            }else{
                tokenDict = ["Content-Type": "application/json" ]
            }
            print("Bearer \(defaults.value(forKey: kAuthToken))")
            print("parms \(parameters)")
            
            AF.request(url, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseString { response in
                print("Request parameters : \(String(describing: parameters))")   // original url request
                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(String(describing: response.result.value))")                   // response serialization result
                if let jsonData = response.value?.data(using: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        print("Result json : \(json)")
                    }catch(let error){
                        print("error : \(error)")
                    }
                }
                NetworkManager.parseResponse(response: response, completion: completion)
                }
            }
        
    }
    
    //:- MARK get Data APi
    static func callServiceGet(fullUrl:String, parameters: [String:Any]?, httpMethod:HTTPMethod = .get, header: HTTPHeaders = [:], completion: @escaping (NetworkResponseState) -> Void){
        if ReachabilityCheck.isConnectedToNetwork() == false{
            completion(.failed(.noInternet(NO_INTERNET_MESSAGE)))
            return
        } else {
            var tokenDict: HTTPHeaders = header
            //        if LoginUserModel.shared.isLogin {
            if (defaults.value(forKey: kAuthToken) as? String) != "" {
                tokenDict["Content-Type"] = "application/json"
                tokenDict["Authorization"] = "Bearer \(defaults.value(forKey: kAuthToken) ?? "")"

            }else{
                tokenDict = ["Content-Type": "application/json" ]
            }
            print("Bearer \(defaults.value(forKey: kAuthToken))")
            //        print("parms \(parameters)")
            AF.request(fullUrl, method:httpMethod, parameters:parameters, encoding: JSONEncoding.default,headers: tokenDict).responseString { response in
                print("Request parameters : \(String(describing: parameters))")
                print("Request: \(String(describing: response.request))")
                if let jsonData = response.value?.data(using: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        print("Result json : \(json)")
                    }catch(let error){
                        print("error : \(error)")
                    }
                }
                NetworkManager.parseResponse(response: response, completion: completion)
            }
        }
        
    }
    
    
    static func callServiceMultipalFiles(url: String, files:[SSFiles], parameters:Parameters, completion: @escaping (NetworkResponseState) -> Void) {
        
        if ReachabilityCheck.isConnectedToNetwork() == false{
            completion(.failed(.noInternet(NO_INTERNET_MESSAGE)))
            return
        } else {
            var  tokenDict:HTTPHeaders = [:]
            //        if LoginUserModel.shared.isLogin {
            //
            if (defaults.value(forKey: kAuthToken) as? String) != "" {
                tokenDict["Content-Type"] = "application/json"
                tokenDict["Authorization"] = "Bearer \(defaults.value(forKey: kAuthToken) ?? "")"
                tokenDict["Accept"] = "application/json"
            }else{
                tokenDict = ["Content-Type": "application/json"]
                tokenDict["Accept"] = "application/json"

            }
            print("parameters: \(parameters)")
            print("api url form data: \(url)")

            AF.upload( multipartFormData: { multipartFormData in
                    
//                    for (key, value) in parameters {
//
//                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }

                parameters.forEach { (key, value) in
                    if let arrdata = (value as? [AnyHashable : Any]) {
                        if arrdata.count > 0 {
                            let arrdatas =  try! JSONSerialization.data(withJSONObject: arrdata, options: [])
                            multipartFormData.append(arrdatas, withName: key as String)
                        }
                    }
                    guard
                        let data = (value as? String)?
                            .data(using: .utf8)
                    else { return }
                    multipartFormData.append(data, withName: key)
                }

            
                    var count = 0
                    for item in files {
                        if let fileUrl: URL = item.url {
                            do {
                                let data = try Data(contentsOf: fileUrl )
                                multipartFormData.append(data, withName: item.paramKey, fileName: (fileUrl.absoluteString as NSString).lastPathComponent, mimeType: "application/octet-stream")
                                
                                var fileName: String = (fileUrl.absoluteString as NSString).lastPathComponent
                                fileName = fileName.replacingOccurrences(of: ".\(fileUrl.pathExtension)", with: ".jpg")
                                if  let thumb: UIImage = item.thumbImage {
                                    multipartFormData.append(thumb.jpegData(compressionQuality: 1.0)!, withName: "video_thumbnail[\(count)]", fileName: fileName, mimeType: "image/jpg")
                                }
                                
                                count = count + 1
                            } catch let error{
                                print(error)
                            }
                        } else if let image = item.image {
                            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                                print("Could not get JPEG representation of UIImage")
                                return
                            }
                            
                            let fileName: String = "\(Date().timeIntervalSince1970).jpg"
                            multipartFormData.append(imageData, withName: item.paramKey, fileName: fileName, mimeType: "image/jpg")
                            
                            if  let thumb: UIImage = item.thumbImage {
                                multipartFormData.append(thumb.jpegData(compressionQuality: 1.0)!, withName: "video_thumbnail[\(count)]", fileName: fileName, mimeType: "image/jpg")
                            }
                            count = count + 1
                        }
                    }
                },
                to: url, method: .post , headers: tokenDict)
                .responseString { (response) in
                    print("response : \(response)")
                    NetworkManager.parseResponse(response: response, completion: completion)
                }
        }
    }

    static func callServiceGetMethod(url:String, completion:@escaping (NetworkResponseState) -> Void){
        if ReachabilityCheck.isConnectedToNetwork() == false{
            completion(.failed(.noInternet(NO_INTERNET_MESSAGE)))
            return
        } else {
            var tokenDict:HTTPHeaders = [:]
            if (defaults.value(forKey: kAuthToken) as? String) != "" {
                tokenDict = ["Content-Type": "application/json", "Authorization": "Bearer \(defaults.value(forKey: kAuthToken) ?? "")" ]
            }else{
                tokenDict = ["Content-Type": "application/json" ]
            }
            print("Bearer \(defaults.value(forKey: kAuthToken) ?? "")")
            AF.request(url, method:.get, headers:tokenDict).responseString { response in
                
                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(String(describing: response.result))") // response serialization result
                if let jsonData = response.value?.data(using: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        print("Result json : \(json)")
                    }catch(let error){
                        print("error : \(error)")
                    }
                }
                NetworkManager.parseResponse(response: response, completion: completion)
            }
        }
    }
    
    static func clearLocaldataGotoLogin(gotoLogin : Bool = false){
        
//        defaults.removeObject(forKey: IS_LOGIN)
//        defaults.removeObject(forKey: "AuthToken")
//        defaults.removeObject(forKey: USER_SAVED_LAT)
//        defaults.removeObject(forKey: USER_SAVED_LONG)
//        defaults.removeObject(forKey: USER_SAVED_ADDRESS)
//
//        if gotoLogin {
//            let nav1 = UINavigationController()
//            nav1.isNavigationBarHidden = true
//            let mainView = LoginViewController()
//            nav1.viewControllers = [mainView]
//            UIApplication.shared.windows.first?.rootViewController = nav1
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
//        }
        
        
    }
}

public enum ErrorResponseType {
    case logout(String)
    case serverError(String)
    case noContant(String)
    case noInternet(String)
}

public enum NetworkResponseState {
    case success([String:Any])
    case failed(ErrorResponseType)
}

//public enum NetworkResponseStateNew {
//    case success([String:Any])
//    case failed(String)
//    case noDataFound
//    case unknownError(String)
//    case serverSideError
//    case unauthorised
//}

public enum CheckStatusNetworkResponse {
    case success
    case failed(String)
}

public enum ViewModelResponseState {
    case success(String)
    case failed(String)
}

