//
//  ProfileViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 24.10.2024.
//

import UIKit
import Kingfisher

final class ProfileViewModel {
    
    private let getUserDataUseCase: GetUserDataUseCase
    
    var userData = UserData()
    
    var onDidLoadUserData: ((UserData) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    
    init() {
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
    }
    
    func onDidLoad() {
        Task { @MainActor in
            onDidStartLoad?()
        }
        
        Task {
            do {
                userData = try await fetchUserData()
                onDidLoadUserData?(userData)
                Task { @MainActor in
                    onDidFinishLoad?()
                }
            } catch {
                Task { @MainActor in
                    onDidFinishLoad?()
                }
            }
        }
    }
    
    private func fetchUserData() async throws -> UserData {
        do {
            let userData = try await getUserDataUseCase.execute()
            return mapToUserData(userData)
        } catch {
            print("Ошибка загрузки профиля: \(error)")
            throw error
        }
    }
    
    private func mapToUserData(_ userData: UserDataResponseModel) -> UserData {
        return UserData(
            id: userData.id,
            username: userData.nickName,
            email: userData.email,
            profileImageURL: userData.avatarLink ?? Constants.profileImageBaseURL,
            name: userData.name,
            birthDate: userData.birthDate,
            gender: Gender(rawValue: userData.gender) ?? .male
        )
    }
}

private extension ProfileViewModel {
    enum Constants {
        static let profileImageBaseURL = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aP-DnfZtz5g1kqZ95jUOrbSD2MFbR26TDF19ilFYm-evqwBPOGIgbJ5B-y1-fc1vklQPxEGCv-N8cnyPAB~d-qXI0osxOBI2uZvBdijubw74D~EmvMyHxv0Uiap-1gfUg0y~szKlCPRAcF0HgVnfdkJXnDrhAimYZ1e3jkaTVHWrc-yyx-2Y-L9U2Gl1HhxCIju6RKLVdYCwC1Rc-UtB-023Ew1yJiK7gTnp06STegfVbQU5S2gJc1Seid38IACKNxL4dgN8ECuorGEtZ6Gnz~zThzwTxBuVh3xuipifjV828io6PIl1fDe5gRutX3gcL6ajvcd2CaHQWKtW94Ci~A__"
    }
}
