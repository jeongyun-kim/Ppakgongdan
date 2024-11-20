//
//  Resources.swift
//  Common
//
//  Created by 김정윤 on 10/29/24.
//

import SwiftUI

public enum Resources {
    public enum Images {
        public static let appleLogin = Image("AppleLogin")
        public static let kakaoLogin = Image("KakaoLogin")
        public static let emailLogin = Image("EmailButton")
        public static let camera = Image("Camera")
        public static let dummy = Image("Dummy")
        public static let noPhotoA = Image("No Photo A")
        public static let noPhotoB = Image("No Photo B")
        public static let noPhotoC = Image("No Photo C")
        public static let sesacBot = Image("SesacBot")
        public static let newMessage = Image("New_Message_Button")
        public static let chevronDown = Image("chevron_down")
        public static let chevronLeft = Image("chevron_left")
        public static let chevronRight = Image("chevron_right")
        public static let chevronUp = Image("chevron_up")
        public static let close = Image("close")
        public static let email = Image("email")
        public static let help = Image("help")
        public static let home = Image("home")
        public static let homeActive = Image("home_active")
        public static let message = Image("message")
        public static let messageActive = Image("message_active")
        public static let onboarding = Image("onboarding")
        public static let plus = Image("plus")
        public static let profile = Image("profile")
        public static let profileActive = Image("profile_active")
        public static let setting = Image("setting")
        public static let settingActive = Image("setting_active")
        public static let thick = Image("thick")
        public static let hashTag = Image(systemName: "number")
        public static let thin = Image("thin")
        public static let threeDots = Image("three dots")
        public static let workspace = Image("workspace")
        public static let logo = Image("logo")
        public static let emptyHomeImage = Image("EmptyHomeImage")
        public static let defaultGroupImage = Image("Group")
        public static let UIdefaultGroupImage = UIImage(named: "Group")
    }
    
    public enum Colors {
        public static let bgPrimary = Color("BgPrimary")
        public static let bgSecondary = Color("BgSecondary")
        public static let black = Color("Black")
        public static let error = Color("Error")
        public static let gray = Color("Gray")
        public static let inActive = Color("InActive")
        public static let primaryColor = Color("PrimaryColor")
        public static let secondaryColor = Color("SecondaryColor")
        public static let white = Color("White")
        public static let textPrimary = Color("TextPrimary")
        public static let textSecondary = Color("TextSecondary")
        public static let seperator = Color("Seperator")
        public static let viewAlpha = Color("ViewAlpha")
        public static let pointColor = Color(.blue)
    }
   
    public enum Fonts {
        public static let title1: Font = .system(size: 22, weight: .bold)
        public static let title2: Font = .system(size: 14, weight: .bold)
        public static let bodyBold: Font = .system(size: 13, weight: .bold)
        public static let body: Font = .system(size: 13, weight: .regular)
        public static let caption: Font = .system(size: 12, weight: .regular)
    }
    
    public enum Corners {
        public static let normal: CGFloat = 8
        public static let sideMenu: CGFloat = 25
    }
}
