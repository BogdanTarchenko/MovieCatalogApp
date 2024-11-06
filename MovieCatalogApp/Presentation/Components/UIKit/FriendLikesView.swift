//
//  FriendsLikesView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 05.11.2024.
//

import SwiftUI
import Kingfisher

struct FriendLikesView: View {
    let friends: [Friend]
    let reviews: [ReviewDetails]
    
    var likedFriends: [Friend] {
        let likedFriendIds = reviews
            .filter { $0.rating > 6 }
            .compactMap { $0.author.userId }
        
        return friends
            .filter { likedFriendIds.contains($0.userId ?? SC.empty) }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            if !likedFriends.isEmpty {
                HStack(spacing: 8) {
                    ForEach(likedFriends, id: \.userId) { friend in
                        if let avatarLink = friend.avatarLink,
                           let url = URL(string: avatarLink) {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .padding(.leading, -16)
                        } else {
                            if let url = URL(string: Constants.defaultAvatarLink) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                    .padding(.leading, -16)
                            }
                        }
                    }
                    
                    Text("\(LocalizedString.MovieDetails.like) \(likedFriends.count) \(LocalizedString.MovieDetails.yourFriends)")
                        .font(.custom("Manrope-Medium", size: 16))
                        .foregroundStyle(.textDefault)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 32)
                .padding(.trailing, 16)
                .padding(.vertical, 16)
                .background(Color(.darkFaded))
                .cornerRadius(16)
            }
        }
    }
}

extension FriendLikesView {
    enum Constants {
        static var defaultAvatarLink: String = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=NChlGzcfGZDhcEKxSkCuF2s07eic2KBzFrFDqDNR-cLTSRdLnoGdp3lgKFZJ70jgBCxUWz6J7LE~nBKRbeBagiPAx6PEpRfiaTPv5B5YMnrjkP3m9OshStQuDb7LJyufIqH1swKkFOywX7Wo3uEwUtueMagv6J~UzRAPWoxqvgJaRbi2uET-TmmLY4bCcB8tqfvPaCrjKm0ajPGWlpP7TzTfEuZbulvT2MgKpg5taY4z-iXg6Mrww8Xge05ioMU5V4raAnRNpOgFyRGbq3ZZkT1LsKjQ4HLyLWxycmaukA1zWwLcm7OfsDlOx~OB3Uwkl04nTnIxe8NfaOEwQSb1FQ__"
    }
}

