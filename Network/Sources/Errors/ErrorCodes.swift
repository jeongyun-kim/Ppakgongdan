//
//  ErrorCodes.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/3/24.
//

import Foundation

public enum ErrorCodes: String, CaseIterable, Error {
    case E00 // 그 외 오류
    case E01 // 접근권한
    case E02 // 인증 실패
    case E03 // 로그인 실패(알 수 없는 계정)
    case E05 // 액세스 토큰 만료
    case E11 // 잘못된 요청
    case E12 // 중복 데이터
    case E97 // 알 수 없는 라우터 경로
    case E98 // 과호출
    case E99 // 서버 오류
}
