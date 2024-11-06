//
//  FriendView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import UIKit
import SnapKit
import Kingfisher

class FriendCell: UICollectionViewCell {
    
    var action: () -> Void = {}
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let closeButton = UIButton()
    
    var avatarLink: String? {
        didSet {
            if let avatarLink = avatarLink, let url = URL(string: avatarLink) {
                avatarImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: Constants.defaultAvatarLink),
                    completionHandler: { result in
                        switch result {
                        case .failure:
                            self.avatarImageView.kf.setImage(with: URL(string: Constants.defaultAvatarLink))
                        case .success:
                            break
                        }
                    }
                )
            } else {
                avatarImageView.image = UIImage(named: Constants.defaultAvatarLink)
            }
        }
    }

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 48
        avatarImageView.layer.masksToBounds = true
        contentView.addSubview(avatarImageView)
        
        nameLabel.font = UIFont(name: "Manrope-Medium", size: 14)
        nameLabel.textColor = .textDefault
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        closeButton.setImage(UIImage(named: "crossButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        contentView.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top)
            make.right.equalTo(avatarImageView.snp.right)
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func closeButtonTapped() {
        action()
    }
}

extension FriendCell {
    enum Constants {
        static var defaultAvatarLink: String = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=NChlGzcfGZDhcEKxSkCuF2s07eic2KBzFrFDqDNR-cLTSRdLnoGdp3lgKFZJ70jgBCxUWz6J7LE~nBKRbeBagiPAx6PEpRfiaTPv5B5YMnrjkP3m9OshStQuDb7LJyufIqH1swKkFOywX7Wo3uEwUtueMagv6J~UzRAPWoxqvgJaRbi2uET-TmmLY4bCcB8tqfvPaCrjKm0ajPGWlpP7TzTfEuZbulvT2MgKpg5taY4z-iXg6Mrww8Xge05ioMU5V4raAnRNpOgFyRGbq3ZZkT1LsKjQ4HLyLWxycmaukA1zWwLcm7OfsDlOx~OB3Uwkl04nTnIxe8NfaOEwQSb1FQ__"
    }
}
