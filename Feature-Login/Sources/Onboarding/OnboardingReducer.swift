//
//  OnboardingReducer.swift
//  Feature-Login
//
//  Created by 김정윤 on 11/1/24.
//

import AuthenticationServices
import ComposableArchitecture
import KakaoSDKUser
import NetworkKit
import Utils

@Reducer
public struct OnboardingReducer {
    public init() { }
    private let ud = UserDefaultsManager.shared
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var isPresentingSheet = false
        var isUser = UserDefaultsManager.shared.isUser
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case present
        case appleLoginBtnTapped(Result<ASAuthorization, any Error>)
        case kakaoLoginBtnTapped
        case loginFailed
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .present:
                state.isPresentingSheet.toggle()
                return .none
                
            case .binding(_):
                return .none
                
            case .loginFailed:
                print("Failed Login")
                return .none
            
            case .appleLoginBtnTapped(let result):
                switch result {
                case .success(let result):
                    switch result.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        guard let tokenData = appleIDCredential.identityToken else { return .send(.loginFailed) }
                        guard let idToken = String(data: tokenData, encoding: .utf8) else { return .send(.loginFailed) }
                        let fullName = appleIDCredential.fullName
                        let nickname = (fullName?.familyName ?? "빡공단원") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email ?? ""
                        Task {
                            do {
                                let query = AppleLoginQuery(idToken: idToken, nickname: nickname, deviceToken: ud.deviceToken)
                                let result = try await NetworkService.shared.postAppleLogin(query)
                                print("👍 Post AppleLogin Success: \(result)")
                                saveAppleDatas(email: email, data: result)
                            } catch {
                                print("❗️Error: ", error)
                            }
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    print("❗️Error: ", error)
                    return .send(.loginFailed)
                }
                return .none
                
            case .kakaoLoginBtnTapped:
                // 카카오톡으로 로그인 가능하다면
                guard UserApi.isKakaoTalkLoginAvailable() else { return .send(.loginFailed) }
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    guard let oauthToken else { return }
                    Task {
                        var query = KakaoLoginQuery(oauthToken: "", deviceToken: "")
                        query.oauthToken = oauthToken.accessToken
                        query.deviceToken = ud.deviceToken
                        do {
                            let result = try await NetworkService.shared.postKakaoLogin(query)
                            print("👍 Post KakaoLogin Success: \(result)")
                            saveKakaoDatas(data: result)
                        } catch {
                            print("❗️Error: ", error)
                        }
                    }
                }
                return .send(.present)
            }
        }
    }
    
    private func saveAppleDatas(email: String, data: LoginModel) {
        ud.isApple = true
        ud.isUser = true
        ud.email = email
        ud.accessToken = data.token.accessToken
        ud.refreshToken = data.token.refreshToken
    }
    
    private func saveKakaoDatas(data: LoginModel) {
        ud.accessToken = data.token.accessToken
        ud.refreshToken = data.token.refreshToken
        ud.isKakao = true
        ud.isUser = true
    }
}
