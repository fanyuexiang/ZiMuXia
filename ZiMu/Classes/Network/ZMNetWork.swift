//
//  ZMNetwork.swift
//  ZiMu
//
//  Created by FanYuepan on 2018/3/25.
//  Copyright © 2018年 Fancy. All rights reserved.
//

//
//  WTNetwork.swift
//  together
//
//  Created by fancy on 2018/1/28.
//  Copyright © 2018年 wonder Technology Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import QMUIKit

// MARK: - RequestTarget
protocol  RequestTarget {
    var path: String { get }
    var method: RequestType { get }
    var parameters: [String: Any]? { get }
}

extension RequestTarget {
    var BaseUrl: String {
        return "https://pixabay.com/api/"
    }
    
    var encoding: URLEncoding {
        return URLEncoding.default
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}

enum  RequestType :Int{
    case get
    case post
    case put
    case delete
}

// MARK: - error 处理
class ZMError {
    static let parseJSONError: NSError = NSError(domain: "Server", code: -999, userInfo: [NSLocalizedDescriptionKey: "没有数据"])
    static let parseHtmlError: NSError = NSError(domain: "Server", code: -999, userInfo: [NSLocalizedDescriptionKey: "解析失败"])
    static let otherError: NSError = NSError(domain: "Server", code: -999, userInfo: [NSLocalizedDescriptionKey: "其他错误"])
    
    class func handleError(_ error: Error?) -> Void {
        if error == nil { return }
        guard let error = error as NSError? else { return }
        let msg: String = error.localizedDescription
        QMUITips.show(withText: msg)
    }
}


// MARK: - response 处理
enum WTResponseResult<T> {
    case success(T)
    case failure(NSError?)
}
typealias JsonCallback = (DataResponse<Any>?, _ error: NSError?) -> Void
typealias ResponseCallBack<T> = (WTResponseResult<T>) -> Void

extension DataResponse {
    func mapObject<T: Mappable>(type: T.Type, key: String? = nil, callback:@escaping ResponseCallBack<T>) {
        guard let json = result.value as? [String:Any] else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        guard let data = (key == nil ? json : json[key!]) as? [String:Any] else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        guard let object = Mapper<T>().map(JSON: data) else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        callback(.success(object))
    }
    
    func mapArray<T: Mappable>(type: T.Type, key: String? = nil, callback:@escaping ResponseCallBack<[T]>) {
        guard let json = result.value as? [String:Any] else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        guard let data = (key == nil ? json : json[key!]) as? [[String:Any]] else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        let array =  Mapper<T>().mapArray(JSONArray: data)
        callback(.success(array))
    }
    
    func mapDictionary(callback:@escaping ResponseCallBack<[String:Any]>) {
        guard let json = result.value as? [String:Any] else {
            callback(.failure(ZMError.parseJSONError))
            return
        }
        callback(.success(json))
    }
}

// MARK: - 网络工具
final class ZMNetWork {
    static let shared = ZMNetWork()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    internal var headers: [String: String] = [:]
    
    internal lazy var manger: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        return SessionManager(configuration: configuration)
    }()
    
    private init() {
        configNetworkReachabilityListener()
    }
    
    private func configNetworkReachabilityListener() {
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                //Show error state
                QMUITips.show(withText: "网络连接已断开，请检查设置")
            case .reachable(_), .unknown:
                break
            }
        }
    }
    
    public func getDataFromAPI<T: RequestTarget>(requestTarget: T, callback: @escaping JsonCallback) {
        getDataFromUrl(requestTarget.method, requestUrl: requestTarget.BaseUrl + requestTarget.path, params: requestTarget.parameters, encoding: requestTarget.encoding, callback: callback)
    }
    
    public func getHtmlString(url: String, callback: @escaping ((DataResponse<String>) -> Void)) {
        manger.request(url)
              .validate()
              .responseString(encoding: .utf8, completionHandler: callback)
    }
    
    
    fileprivate func getDataFromUrl(_ method: RequestType, requestUrl: String, params: [String : Any]? = nil, encoding: URLEncoding, callback: @escaping JsonCallback) {
        if method == RequestType.get {
            request("get",urlString: requestUrl, params: params, encoding: encoding, callback: callback)
        } else if (method == RequestType.post) {
            request("post",urlString: requestUrl, params: params, encoding: encoding, callback: callback)
        } else if (method == RequestType.delete) {
            request("delete",urlString: requestUrl, params: params, encoding: encoding, callback: callback)
        } else if (method == RequestType.put) {
            request("put",urlString: requestUrl, params: params, encoding: encoding, callback: callback)
        }
    }
    
    fileprivate func request(_ httpMethod: String, urlString: String, params: [String : Any]?, encoding: URLEncoding, callback: @escaping JsonCallback) {
        var method: HTTPMethod = .get
        switch httpMethod {
        case "post":
            method = .post
        case "delete":
            method = .delete
        case "put":
            method = .put
        default:
            method = .get
        }
        guard let url = URL(string: urlString) else {
            return
        }
        manger.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (response) in
                #if DEBUG
                    print("\n---------------------")
                    print("参数: " + "\(String(describing: params))")
                    print("url: " + "\(String(describing: response.response?.url))")
                    print("状态码: " + "\(response.response?.statusCode ?? 0)")
                    print("返回数据: " + "\(String(describing: response.result.value))")
                    print("\n")
                #endif
                let error = ZMNetWork.parseError(response)
                callback(response, error)
        }
    }
    
    /// parse server error
    ///
    /// example response:
    /*
     {
     "code": 0,
     "errorInfo": "验证失败",
     "data": null,
     "success": false
     }
     */
    /// - Returns: server error
    fileprivate static func parseError(_ response: DataResponse<Any>) -> NSError? {
        var error: NSError?
        if let value = response.result.value as? [String:Any] {
            if let result = value["success"] as? Bool {
                if !result {
                    var msg = ""
                    if let errorInfo = value["errorInfo"] as? String {
                        msg = errorInfo
                    } else {
                        msg = "请求错误"
                    }
                    error = NSError(domain: "Server", code: value["code"] as! Int, userInfo: [NSLocalizedDescriptionKey: msg])
                }
            }
        }
        if error == nil && response.result.error != nil {
            error = response.result.error as NSError?
        }
        return error
    }
    
}

