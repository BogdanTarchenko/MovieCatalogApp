//
//  CarouselView.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

import UIKit

final class CarouselView: UICollectionView {

    var inset: CGFloat = 0 {
        didSet {
            updateLayoutInsets()
        }
    }
    
    var itemSpacing: CGFloat = 8.0 {
        didSet {
            updateItemSpacing()
        }
    }
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = scrollDirection
        }
    }

    convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
        self.inset = inset
        self.decelerationRate = .normal
        updateLayoutInsets()
        updateItemSpacing()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCellScaling()
    }

    // MARK: - Private Methods
    private func updateLayoutInsets() {
        (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    private func updateItemSpacing() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = itemSpacing
        }
    }

    private func updateCellScaling() {
        guard let visibleCells = visibleCells as? [CarouselCell] else { return }
        
        let centerOffset = contentOffset.x + bounds.size.width / 2
        let maxDistance = (bounds.size.width / 2) + (visibleCells.first?.bounds.size.width ?? 0) / 2 + inset
        
        for cell in visibleCells {
            let cellCenter = cell.center.x
            let distanceFromCenter = abs(cellCenter - centerOffset)
            let scale = max(1.0 - (distanceFromCenter / maxDistance) * 0.2, 0.8)
            let alpha = max(1.0 - (distanceFromCenter / maxDistance) * (1.0 - cell.alphaMinimum), cell.alphaMinimum)
            
            cell.updateScaleAndAlpha(scale: scale, alpha: alpha)
        }
    }
}
