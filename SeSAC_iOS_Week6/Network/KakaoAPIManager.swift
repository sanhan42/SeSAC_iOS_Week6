//
//  KakaoAPIManager.swift
//  SeSAC_iOS_Week6
//
//  Created by 한상민 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    private init () {}
    
    let headers: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
       
        AF.request(url,method: .get, headers: headers).validate(statusCode: 200...300).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
