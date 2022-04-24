//
//  APIService.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import Foundation
import Moya

enum GitHubSearchAPI {
    case searchUser(parameter: [String: Any])
}

extension GitHubSearchAPI: TargetType {

    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }

    var path: String {
        switch self {
        case .searchUser: return "/search/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .searchUser: return .get
        }
    }

    var task: Task {
        switch self {
        case .searchUser(let parameter): return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .searchUser: return [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": APIKey.authorization
        ]
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
