//
//  ProfileViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 24.10.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewModelDelegate: AnyObject {
    func navigateToWelcome()
    func navigateToFriends()
}

final class ProfileViewModel {
    
    weak var delegate: ProfileViewModelDelegate?
    
    private let getUserDataUseCase: GetUserDataUseCase
    private let changeUserDataUseCase: ChangeUserDataUseCase
    private let logoutUseCase: LogoutUseCase
    
    var userData = UserData()
    var friendsData: [Friend] = []
    
    var onDidLoadUserData: ((UserData) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    var onPresentAlert: ((String, String) -> Void)?
    
    private let dataController = DataController.shared
    
    init() {
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
        self.changeUserDataUseCase = ChangeUserDataUseCaseImpl.create()
        self.logoutUseCase = LogoutUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                userData = try await fetchUserData()
                updateFriends()
                onDidLoadUserData?(userData)
                notifyLoadingFinish()
            } catch {
                notifyLoadingFinish()
            }
        }
    }
    
    func onLogoutButtonTapped() {
        notifyLoadingStart()
        
        Task {
            do {
                try await logoutUseCase.execute()
                notifyLoadingFinish()
                delegate?.navigateToWelcome()
            } catch {
                notifyLoadingFinish()
            }
        }
    }
    
    func friendsButtonTapped() {
        delegate?.navigateToFriends()
    }
    
    func updateFriends() {
        friendsData = dataController.getFriends(for: userData.id)
    }
    
    func showInputAlert(title: String, message: String) {
        onPresentAlert?(title, message)
    }
    
    func updateProfileImage(with urlString: String) {
        userData.profileImageURL = urlString
        onDidLoadUserData?(userData)
        Task {
            try? await changeUserData()
        }
    }
    
    // MARK: - User Data
    func changeUserData() async throws {
        let requestModel = mapToUserDataRequestModel(userData)
        
        do {
            try await changeUserDataUseCase.execute(request: requestModel)
        } catch {
            throw error
        }
    }
    
    // MARK: - Time
    func getCurrentTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    func getCurrentDayTime() -> DayTime {
        let hour = getCurrentTime()
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .day
        case 18..<24: return .evening
        default: return .night
        }
    }
    
    func getCurrentGreeting() -> String {
        switch getCurrentDayTime() {
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
    
    // MARK: - Private Methods
    private func notifyLoadingStart() {
        Task { @MainActor in
            onDidStartLoad?()
        }
    }
    
    private func notifyLoadingFinish() {
        Task { @MainActor in
            onDidFinishLoad?()
        }
    }
    
    private func fetchUserData() async throws -> UserData {
        do {
            let userDataResponse = try await getUserDataUseCase.execute()
            return mapToUserData(userDataResponse)
        } catch {
            throw error
        }
    }
    
    private func mapToUserData(_ userDataResponse: UserDataResponseModel) -> UserData {
        return UserData(
            id: userDataResponse.id,
            username: userDataResponse.nickName,
            email: userDataResponse.email,
            profileImageURL: userDataResponse.avatarLink ?? Constants.profileImageBaseURL,
            name: userDataResponse.name,
            birthDate: userDataResponse.birthDate,
            gender: Gender(rawValue: userDataResponse.gender) ?? .male
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
            gender: userData.gender.rawValue
        )
    }
}

private extension ProfileViewModel {
    enum Constants {
        static let profileImageBaseURL = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aP-DnfZtz5g1kqZ95jUOrbSD2MFbR26TDF19ilFYm-evqwBPOGIgbJ5B-y1-fc1vklQPxEGCv-N8cnyPAB~d-qXI0osxOBI2uZvBdijubw74D~EmvMyHxv0Uiap-1gfUg0y~szKlCPRAcF0HgVnfdkJXnDrhAimYZ1e3jkaTVHWrc-yyx-2Y-L9U2Gl1HhxCIju6RKLVdYCwC1Rc-UtB-023Ew1yJiK7gTnp06STegfVbQU5S2gJc1Seid38IACKNxL4dgN8ECuorGEtZ6Gnz~zThzwTxBuVh3xuipifjV828io6PIl1fDe5gRutX3gcL6ajvcd2CaHQWKtW94Ci~A__"
    }
}
