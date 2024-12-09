//
//  RoundedImageView.swift
//  UI
//
//  Created by 김정윤 on 11/24/24.
//

import SwiftUI
import Kingfisher

public struct RoundedImageView: View {
    public enum ImageViewCase: CGFloat {
        case groupCoverImage = 32
        case horizontaldDmListProfile = 44
        case chattingProfile = 34
        
        var radius: CGFloat {
            return Resources.Corners.normal
        }
        
        var defaultImage: Image {
            switch self {
            case .groupCoverImage:
                return Resources.Images.defaultGroupImage
            default:
                return Resources.Images.noPhotoA
            }
        }
    }
    
    public init(imageViewCase: ImageViewCase, imagePath: String? = nil) {
        self.imageViewCase = imageViewCase
        self.imagePath = imagePath
    }
    
    private let imageViewCase: ImageViewCase
    private let imagePath: String?
    
    public var body: some View {
        if let imagePath {
            VStack {
                KFImage(imagePath.toURL)
                    .resizable()
                    .frame(width: imageViewCase.rawValue, height: imageViewCase.rawValue)
                    .cornerRadius(imageViewCase.radius)
            }
        } else {
            VStack {
                imageViewCase.defaultImage
                    .resizable()
                    .frame(width: imageViewCase.rawValue, height: imageViewCase.rawValue)
                    .cornerRadius(imageViewCase.radius)
            }
        }
    }
}
