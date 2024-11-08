//
//  CreateWorkSpace.swift
//  NetworkKit
//
//  Created by 김정윤 on 11/5/24.
//

import Foundation

public struct CreateWorkSpace: Encodable {
    public init(name: String, description: String, image: Data) {
        self.name = name
        self.description = description
        self.image = image
    }
    
    let name: String
    let description: String
    let image: Data
}
