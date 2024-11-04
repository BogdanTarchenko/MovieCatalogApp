//
//  FriendViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import UIKit

final class FriendViewController: UIViewController {
    
    private var viewModel: FriendsViewModel
    private let collectionView: UICollectionView
    
    init(viewModel: FriendsViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let itemWidth = (UIScreen.main.bounds.width - 96) / 3
        layout.itemSize = CGSize(width: itemWidth, height: 120)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func bindViewModel() {
        viewModel.onFriendsDataUpdated = { [weak self] in
            self?.loadFriends()
        }
    }
    
    private func setup() {
        view.backgroundColor = .background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: "FriendCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }
    
    private func loadFriends() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension FriendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.friendsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friend = viewModel.friendsData[indexPath.item]
        
        cell.avatarLink = friend.avatarLink
        cell.name = friend.name
        cell.action = { [weak self] in
            self?.viewModel.deleteFriend(friend: friend)
            self?.viewModel.updateFriends()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 96) / 3
        return CGSize(width: itemWidth, height: 120)
    }
}
