//
//  APIManager.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation
import Moya

final class APIManager {

    static let shared = APIManager()

    private init() {}

    func requestSearchUser(parameter: [String: Any], completion: @escaping (Result<SearchData, SearchError>) -> Void) {

        let provider = MoyaProvider<GitHubSearchAPI>()
        provider.request(.searchUser(parameter: parameter)) { (result) in
            switch result {
            case let .success(response):
                guard let data = try? response.map(SearchUserResponseDTO.self).toEntity() else { return }
                completion(.success(data))
            case let .failure(error):
                let error = error.response?.statusCode ?? 503
                completion(.failure(SearchError(rawValue: error) ?? .serviceError))
            }
        }
    }
}
