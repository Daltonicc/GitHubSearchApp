//
//  NetworkError.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation

enum SearchError: Int, Error {
    case validationFailed = 422
    case serviceError = 503
}

extension SearchError: LocalizedError {
    private var errorDescription: String {
        switch self {
        case .validationFailed: return "검색이 유효하지 않습니다"
        case .serviceError: return "서버 오류로 시도할 수 없습니다"
        }
    }
}
