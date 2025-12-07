//
//  InfiniteCarouselLayout.swift
//  CollectionViewFlowLayoutSamples
//
//  Created by HEssam on 11/25/25.
//

import UIKit

class InfiniteCarouselCircleLayout: UICollectionViewFlowLayout {
    
    private let minScale: CGFloat = 0.6
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        
        itemSize = CGSize(width: 50, height: 50)
        minimumLineSpacing = 30
        sectionInset = UIEdgeInsets(
            top: 0,
            left: (collectionView.bounds.width - itemSize.width)/2,
            bottom: 0,
            right: (collectionView.bounds.width - itemSize.width)/2
        )
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
              let collectionView else { return nil }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let collectionViewWidth = collectionView.bounds.width
        
        let padding: CGFloat = 16 + itemSize.width/2
        let leftBound  = collectionView.contentOffset.x + padding
        let rightBound = collectionView.contentOffset.x + collectionViewWidth - padding
        
        for attr in attributes {
            
            let distanceFromCenter = abs(attr.center.x - centerX)
            // [x,y] [distanceFromCenter, scale] = [0, 1] [collectionViewWidth / 2, minScale]
            // y = (2 * (minScale - 1) / w * x) + 1
            let scale = 1 + 2 * (minScale - 1) / collectionViewWidth * distanceFromCenter
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            attr.zIndex = Int(1000 - distanceFromCenter)

            var attrCenter = attr.center
            if attrCenter.x < leftBound { attrCenter.x = leftBound }
            if attrCenter.x > rightBound { attrCenter.x = rightBound }
            attr.center = attrCenter
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
