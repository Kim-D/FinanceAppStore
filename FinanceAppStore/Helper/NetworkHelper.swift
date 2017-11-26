//
//  NetworkHelper.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 25..
//  Copyright © 2017년 KimD. All rights reserved.
//

import UIKit

class NetworkHelper: NSObject {
    public typealias successHandler = (_ result: AnyObject?) -> Void
    public typealias failHandler = (_ responseCode: Int, _ responseMsg: String) -> Void
    static let networkHelper = NetworkHelper()
    
    private override init() { }
    
    func topFinanceFreeApplications(successHandler: @escaping successHandler, failHandler: @escaping failHandler) {
        guard let request = requestWithHttpMethod("GET", "https://itunes.apple.com/kr/rss/topfreeapplications/limit=50/genre=6015/json", params: nil) else {
            failHandler(-1, "fail")
            return
        }
        networkTask(nsUrlRequest: request, resultType: Feed.self) { (result: Feed?, responseCode, responseMsg) in
            if (result == nil) {
                failHandler(responseCode, responseMsg);
            } else {
                successHandler(result as AnyObject)
            }
        }
    }
    
    func lookupWithId(id: String, successHandler: @escaping successHandler, failHandler: @escaping failHandler) {
        guard let request = requestWithHttpMethod("POST", "https://itunes.apple.com/lookup", params: ["id" : id, "country" : "kr"]) else {
            failHandler(-1, "")
            return
        }
        
        networkTask(nsUrlRequest: request, resultType: LookUp.self) { (result: LookUp?, responseCode, responseMsg) in
            if (result == nil) {
                failHandler(responseCode, responseMsg);
            } else {
                successHandler(result as AnyObject)
            }
        }
    }
    
    func downloadImageWithUrl(imageUrl: String, complete:@escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            complete(nil)
            return
        }
        
        let task = getSession().dataTask(with: url) { (data, response, error) in
            var downloadImage: UIImage? = nil
            if error == nil && ((data?.count)! > 0) && (response as? HTTPURLResponse)?.statusCode == 200 {
                if let imageData = data {
                    downloadImage = UIImage(data: imageData)
                }
            } else {
                if let e = error {
                    print("=== image download error - ", e.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                complete(downloadImage)
            }
        }
        
        task.resume()
    }
    
    func requestWithHttpMethod(_ httpMethod: String, _ url: String, params: NSDictionary?) -> NSURLRequest! {
        var request: NSURLRequest!
        if "POST" == httpMethod {
            if let postUrl = URL(string: url) {
                let mutableRequest = NSMutableURLRequest(url: postUrl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
                mutableRequest.httpMethod = "POST"
                if let httpBodyParams = params {
                    if let httpBody = dictionaryDataToUrlParamsNSString(dictionary: httpBodyParams).data(using: String.Encoding.utf8) {
                        mutableRequest.setValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
                        mutableRequest.httpBody = httpBody
                    }
                }
                request = mutableRequest
            }
        } else {
            var requestUrl = url
            if let urlParams = params {
                requestUrl += "?\(dictionaryDataToUrlParamsNSString(dictionary: urlParams))"
                print("== request Url - \(requestUrl)")
            }
            
            if let getUrl = URL(string: requestUrl) {
                request = NSURLRequest(url: getUrl, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
            }
        }
        return request
    }
    
    func networkTask<T: Codable>(nsUrlRequest: NSURLRequest, resultType: T.Type, resultHandler: @escaping (_ result: T?, _ responseCode: Int, _ responseMsg: String) -> Void) -> Void {
        let task = getSession().dataTask(with: nsUrlRequest as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            print("==== HTTP StatusCode - \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            var responseCode = -1
            var responseMsg = "fail"
            
            if let httpStatusCode = (response as? HTTPURLResponse)?.statusCode {
                responseCode = httpStatusCode
            }
            
            if error == nil && ((data?.count)! > 0) && responseCode == 200 {
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let resultData = try decoder.decode(resultType, from: data!)
                    print(resultData) //Success!!!
                    DispatchQueue.main.async {
                        resultHandler(resultData, responseCode, "SUCCESS")
                    }
                    /*
                    //encoding
                    let temp = try! JSONEncoder().encode(resultData)
                    let json = String(data: temp, encoding: .utf8)!
                    print(json)
                    */
                } catch {
                    responseMsg = error.localizedDescription
                    print("json convert failed in JSONDecoder", responseMsg)
                    DispatchQueue.main.async {
                        resultHandler(nil, responseCode, responseMsg)
                    }
                }
            } else {
                if let e = error {
                    responseMsg = e.localizedDescription
                }
                DispatchQueue.main.async {
                    resultHandler(nil, responseCode, responseMsg)
                }
            }
        }
        task.resume()
    }
    
    func getSession() -> URLSession{
        let config = URLSessionConfiguration.default
        //header 가 있다면 추가
        /*
         var headers : Dictionary<String, String>?
         headers = ["Accept-Language" : "ko"]
         config.HTTPAdditionalHeaders = headers
         */
        config.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }
    
    func dictionaryDataToUrlParamsNSString(dictionary : NSDictionary?) -> String {
        var params : String = "";
        if var dicArray : Array = dictionary?.allKeys {
            for i in 0 ..< dicArray.count {
                if let key = dicArray[i] as? String {
                    if (i == 0) {
                        params = "\(key)=\((dictionary?.object(forKey: key))!)"
                    } else {
                        params = "\(params)&\(key)=\((dictionary?.object(forKey: key))!)"
                    }
                }
            }
        }
        
        
        return params;
    }
}

