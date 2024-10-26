//
//  ProfileViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 24.10.2024.
//

import UIKit
import Kingfisher

final class ProfileViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    private let getUserDataUseCase: GetUserDataUseCase
    private let changeUserDataUseCase: ChangeUserDataUseCase
    private let logoutUseCase: LogoutUseCase
    
    var userData = UserData()
    
    var onDidLoadUserData: ((UserData) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    var onPresentAlert: ((String, String) -> Void)?
    
    init() {
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
        self.changeUserDataUseCase = ChangeUserDataUseCaseImpl.create()
        self.logoutUseCase = LogoutUseCaseImpl.create()
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
    
    func onLogoutButtonTapped() {
        Task { @MainActor in
            onDidStartLoad?()
        }
        
        Task {
            do {
                try await logoutUseCase.execute()
                Task { @MainActor in
                    onDidFinishLoad?()
                }
                appRouterDelegate?.navigateToWelcome()
            } catch {
                Task { @MainActor in
                    onDidFinishLoad?()
                }
            }
        }
    }
    
    func getCurrentTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour
    }
    
    func getCurrentDayTime() -> DayTime {
        let hour = getCurrentTime()
        if (hour >= 6 && hour < 12) {
            return .morning
        }
        else if (hour >= 12 && hour < 18) {
            return .day
        }
        else if (hour >= 18 && hour < 24) {
            return .evening
        }
        else {
            return .night
        }
    }
    
    func getCurrentGreeting() -> String {
        let dayTime: DayTime = getCurrentDayTime()
        switch dayTime {
        case .morning:
            return LocalizedString.Greeting.morning
        case .day:
            return LocalizedString.Greeting.day
        case .evening:
            return LocalizedString.Greeting.evening
        case .night:
            return LocalizedString.Greeting.night
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
    
    private func mapToUserDataRequestModel(_ userData: UserData) -> UserDataRequestModel {
        return UserDataRequestModel(
            id: userData.id,
            nickName: userData.username,
            email: userData.email,
            avatarLink: userData.profileImageURL,
            name: userData.name,
            birthDate: userData.birthDate,
            gender: userData.gender.rawValue)
    }
    
    func showInputAlert(title: String, message: String) {
        onPresentAlert?(title, message)
    }
    
    func updateProfileImage(with urlString: String) {
        userData.profileImageURL = urlString
        onDidLoadUserData?(userData)
    }
    
    func changeUserData() async throws {
        let requestModel = mapToUserDataRequestModel(userData)
        
        do {
            try await changeUserDataUseCase.execute(request: requestModel)
        } catch {
            print("Ошибка изменения данных пользователя: \(error)")
            print(requestModel)
            throw error
        }
    }
}

private extension ProfileViewModel {
    enum Constants {
        static let profileImageBaseURL = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aP-DnfZtz5g1kqZ95jUOrbSD2MFbR26TDF19ilFYm-evqwBPOGIgbJ5B-y1-fc1vklQPxEGCv-N8cnyPAB~d-qXI0osxOBI2uZvBdijubw74D~EmvMyHxv0Uiap-1gfUg0y~szKlCPRAcF0HgVnfdkJXnDrhAimYZ1e3jkaTVHWrc-yyx-2Y-L9U2Gl1HhxCIju6RKLVdYCwC1Rc-UtB-023Ew1yJiK7gTnp06STegfVbQU5S2gJc1Seid38IACKNxL4dgN8ECuorGEtZ6Gnz~zThzwTxBuVh3xuipifjV828io6PIl1fDe5gRutX3gcL6ajvcd2CaHQWKtW94Ci~A__"
    }
}
