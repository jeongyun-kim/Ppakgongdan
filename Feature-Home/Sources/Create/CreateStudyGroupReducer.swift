//
//  CreateStudyGroupReducer.swift
//  Feature-Home
//
//  Created by 김정윤 on 11/5/24.
//

import SwiftUI
import PhotosUI
import UI
import Utils
import NetworkKit
import ComposableArchitecture

public struct CreateStudyGroupReducer: Reducer {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(group: Shared<StudyGroup?> = Shared(nil)) {
            _group = group
        }
        
        @Shared var group: StudyGroup?
        var studyGroupName = "" // 스터디그룹명
        var studyGroupDesc = "" // 스터디그룹 설명
        var isDisabled = true // 생성 버튼 활성화 여부
        var selectedImage: PhotosPickerItem? = nil // 현재 선택된 이미지 아이템
        var groupImage: Image? = nil // 스터디그룹 이미지
        var groupImageData: Data? = nil // 스터디그룹 이미지 데이터
        var isPresentingReloginAlert = false // 로그인 알림
        var isCompleted = false // 그룹 생성 작업 완료했는지
    }
    
    public enum Actoin: BindableAction {
        case binding(BindingAction<State>)
        case viewOnAppear
        case changedStudyGroupName
        case changedSelectedImage
        case setImage(Image?, Data?)
        case createStudyGroup
        case toggleReloginAlert
        case toggleCompleted
    }
    
    public var body: some Reducer<State, Actoin> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .viewOnAppear: // 뷰 떠올랐을 때, 기본 이미지 데이터로 변경해두기
                if let _ = state.groupImage {
                    return .none
                } else {
                    let defaultImage = Resources.Images.UIdefaultGroupImage!
                    let defaultImageData = defaultImage.jpegData(compressionQuality: 0.5)
                    state.groupImageData = defaultImageData
                    return .none
                }
                
            case .toggleReloginAlert:
                state.isPresentingReloginAlert.toggle()
                return .none
                
            case .changedStudyGroupName: // 스터디그룹명 입력할 때마다 조건 확인(1자 ~ 30자)
                let groupNameCnt = state.studyGroupName.trimmingCharacters(in: .whitespacesAndNewlines).count
                let result = groupNameCnt < 1 || groupNameCnt > 30
                state.isDisabled = result
                return .none
                
            case .changedSelectedImage: // 이미지 변경 시
                return .run { [selectedImage = state.selectedImage] send in
                    guard let selectedImage else { return }
                    let loadedImage = try await selectedImage.loadTransferable(type: Image.self)
                    let loadedImageData = try await selectedImage.loadTransferable(type: Data.self)
                    await send(.setImage(loadedImage, loadedImageData))
                }
                
            case .setImage(let selectedImage, let selectedImageData):
                state.groupImage = selectedImage
                state.groupImageData = selectedImageData
                return .none
                
            case .createStudyGroup:
                return .run { [imageData = state.groupImageData, name = state.studyGroupName, desc = state.studyGroupDesc] send in
                    guard let imageData else { return }
                    do {
                        let image = imageData
                        let _ = try await NetworkService.shared.createWorkspace(name: name, desc: desc, image: image)
                        await send(.toggleCompleted) // 생성 성공 시 complete 처리
                    } catch {
                        guard let errorCode = error as? ErrorCodes else { return }
                        guard errorCode == .E05 else { return }
                        await send(.toggleReloginAlert)
                    }
                }
                
            case .toggleCompleted: // 그룹 생성 후 현재 뷰 내리도록 isCompleted 값 변경
                state.isCompleted.toggle()
                return .none
            }
        }
    }
}
