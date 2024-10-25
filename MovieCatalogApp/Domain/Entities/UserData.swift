//
//  UserData.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

struct UserData {
    var id: String
    var username: String
    var email: String
    var profileImageURL: String
    var name: String
    var birthDate: String
    var gender: Gender
    
    init(id: String = SC.empty, username: String = SC.empty, email: String = SC.empty, profileImageURL: String = Constants.baseURL, name: String = SC.empty, birthDate: String = SC.empty, gender: Gender = .male) {
        self.id = id
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
    }
}

extension UserData {
    enum Constants {
        static let baseURL = "https://iconduck.com/icons/160691/avatar-default-symbolic"
    }
}
