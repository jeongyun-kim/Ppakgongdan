//
//  OnboardingReducer.swift
//  Feature-Login
//
//  Created by 김정윤 on 11/1/24.
//

import AuthenticationServices
import Utils
import ComposableArchitecture
import KakaoSDKUser

@Reducer
public struct OnboardingReducer {
    private let ud = UserDefaultsManager.shared
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var isPresenting = false
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case present
        case appleLoginBtnTapped(Result<ASAuthorization, any Error>)
        case kakaoLoginBtnTapped
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .present:
                state.isPresenting.toggle()
                return .none
            case .binding(_):
                return .none
            case .appleLoginBtnTapped(let result):
                switch result {
                case .success(let result):
                    print("Apple Login Successful")
                    switch result.credential{
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        // 계정 정보 가져오기
                        let fullName = appleIDCredential.fullName
                        let name =  (fullName?.familyName ?? "빡공단원") + (fullName?.givenName ?? "")
                        let email = appleIDCredential.email ?? ""
                        ud.isApple = true
                        ud.email = email
                    default:
                        break
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("error")
                }
                return .none
            case .kakaoLoginBtnTapped:
                // 카카오톡으로 로그인 가능하다면
                guard UserApi.isKakaoTalkLoginAvailable() else {
                    // 안되면 카카오계정으로 로그인
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        guard let oauthToken else { return }
                        
                    }
                    return .none }
                // 카카오톡으로 로그인
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    guard let oauthToken else { return }
                    
                }
                return .none
            }
        }
    }
}
