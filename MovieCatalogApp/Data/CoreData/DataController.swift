//
//  DataController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

import CoreData

class DataController {
    static let shared = DataController()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "UserDB")
        persistentContainer.loadPersistentStores { _, _ in }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension DataController {
    
    // MARK: User
    func createUserIfNeeded(userId: String) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if (try? context.fetch(request))?.isEmpty ?? true {
            let newUser = User(context: context)
            newUser.userId = userId
            saveContext()
        }
    }
    
    // MARK: - Favorite Genres
    func addFavoriteGenre(for userId: String, genreName: String) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            let genreFetchRequest = NSFetchRequest<FavoriteGenre>(entityName: "FavoriteGenre")
            genreFetchRequest.predicate = NSPredicate(format: "name == %@", genreName)
            
            let favoriteGenre: FavoriteGenre
            if let existingGenre = (try? context.fetch(genreFetchRequest))?.first {
                favoriteGenre = existingGenre
            } else {
                favoriteGenre = FavoriteGenre(context: context)
                favoriteGenre.name = genreName
            }
            
            user.addToFavoriteGenres(favoriteGenre)
            saveContext()
        }
    }
    
    func removeFavoriteGenre(for userId: String, genreName: String) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first,
           let genres = user.favoriteGenres as? Set<FavoriteGenre> {
            if let genreToRemove = genres.first(where: { $0.name == genreName }) {
                user.removeFromFavoriteGenres(genreToRemove)
                saveContext()
            }
        }
    }
    
    func getFavoriteGenres(for userId: String) -> [FavoriteGenre] {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            return user.favoriteGenres?.allObjects as? [FavoriteGenre] ?? []
        }
        return []
    }
    
    // MARK: - Friends
    func addFriend(for userId: String, friend: Friend) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            if !(user.friends?.contains(where: { ($0 as? Friend)?.userId == friend.userId }) ?? false) {
                user.addToFriends(friend)
                saveContext()
            }
        }
    }

    
    func removeFriend(for userId: String, friend: Friend) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first,
           let friends = user.friends as? Set<Friend> {
            if let friendToRemove = friends.first(where: { $0.userId == friend.userId }) {
                user.removeFromFriends(friendToRemove)
                saveContext()
            }
        }
    }

    
    func getFriends(for userId: String) -> [Friend] {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            return user.friends?.allObjects as? [Friend] ?? []
        }
        return []
    }
    
    // MARK: - Hidden Films
    func hideFilm(for userId: String, film: HiddenFilm) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            if !(user.hiddenFilms?.contains(where: { ($0 as? HiddenFilm)?.movieId == film.movieId }) ?? false) {
                user.addToHiddenFilms(film)
                saveContext()
            }
        }
    }

    
    func unhideFilm(for userId: String, film: HiddenFilm) {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first,
           let hiddenFilms = user.hiddenFilms as? Set<HiddenFilm> {
            if let filmToUnhide = hiddenFilms.first(where: { $0.movieId == film.movieId }) {
                user.removeFromHiddenFilms(filmToUnhide)
                saveContext()
            }
        }
    }
    
    func getHiddenFilms(for userId: String) -> [HiddenFilm] {
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        if let user = (try? context.fetch(request))?.first {
            return user.hiddenFilms?.allObjects as? [HiddenFilm] ?? []
        }
        return []
    }
    
    // MARK: - Save Context
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}

