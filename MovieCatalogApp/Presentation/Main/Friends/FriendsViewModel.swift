//
//  FriendsViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import Foundation

final class FriendsViewModel {
    
    private let dataController = DataController.shared
    private let getUserDataUseCase: GetUserDataUseCase
    
    var currentUserId: String = SC.empty
    var friendsData: [Friend] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.onFriendsDataUpdated?()
            }
        }
    }
    
    var onFriendsDataUpdated: (() -> Void)?
    
    init() {
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
        
        Task {
            self.currentUserId = try await getUserDataUseCase.execute().id
            updateFriends()
        }
    }
    
    func updateFriends() {
        friendsData = dataController.getFriends(for: currentUserId)
    }
    
    func deleteFriend(friend: Friend) {
        dataController.removeFriend(for: currentUserId, friend: friend)
    }
}

