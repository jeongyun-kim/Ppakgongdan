//
//  EmailLoginReducer.swift
//  Feature-Login
//
//  Created by 김정윤 on 11/23/24.
//

import Utils
import UI
import ComposableArchitecture
import NetworkKit
import Foundation

@Reducer
struct EmailLoginReducer {
    @ObservableState
    struct State: Equatable {
        var email = "unknown1@naver.com"
        var password = "@Unknown1234"
        var isValidEmail = false
        var isValidPassword = false
        var isDisabled = true
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case validateEmail
        case validatePassword
        case login
        case loginSuccessful(LoginModel)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .validateEmail:
                state.isValidEmail = state.email.isValidEmail
                state.isDisabled = !(state.isValidEmail && state.isValidPassword)
                return .none
                
            case .validatePassword:
                state.isValidPassword = validatePassword(state.password)
                state.isDisabled = !(state.isValidPassword && state.isValidEmail)
                return .none
                
            case .login:
                return .run { [email = state.email, pw = state.password] send in
                    do {
                        let result = try await NetworkService.shared.postEmailLogin(email: email, passworkd: pw)
                        await send(.loginSuccessful(result))
                    } catch {
                        print(error)
                    }
                }
                
            case .loginSuccessful(let data):
                UserDefaultsManager.shared.accessToken = data.token.accessToken
                UserDefaultsManager.shared.refreshToken = data.token.refreshToken
                UserDefaultsManager.shared.isUser = true
                UserDefaultsManager.shared.userId = data.userId
                return .none
            }
        }
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword(_ pw: String) -> Bool {
        // 비밀번호 길이 체크
        guard pw.count >= 8 else {
            return false
        }
        
        // 정규식 정의
        // - 하나 이상 들어있는지
        let uppercaseRegex = ".*[A-Z].*"
        let lowercaseRegex = ".*[a-z].*"
        let digitRegex = ".*[0-9].*"
        let specialCharacterRegex = ".*[!@#$%^&*(),.?\":{}|<>].*"
            
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
          
        // 각 조건 확인
        let upperCaseResult = uppercasePredicate.evaluate(with: pw)
        let lowerCaseResult = lowercasePredicate.evaluate(with: pw)
        let digitCaseResult = digitPredicate.evaluate(with: pw)
        let specialCharacterCaseResult = specialCharacterPredicate.evaluate(with: pw)
        
        // 모든 조건 충족 시 true
        return upperCaseResult && lowerCaseResult && digitCaseResult && specialCharacterCaseResult
    }
}
