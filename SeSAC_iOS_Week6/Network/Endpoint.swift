//
//  Endpoint.swift
//  SeSAC_iOS_Week6
//
//  Created by 한상민 on 2022/08/08.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog")
        case .cafe:
            return URL.makeEndPointString("cafe")
        }
    }
}
