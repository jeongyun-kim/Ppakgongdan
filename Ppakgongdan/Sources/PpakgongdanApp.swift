import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct PpakgongdanApp: App {
    init() {
        // 앱 실행 시, KakaoSDK 초기화
        KakaoSDK.initSDK(appKey: KakaoAPI.key)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
