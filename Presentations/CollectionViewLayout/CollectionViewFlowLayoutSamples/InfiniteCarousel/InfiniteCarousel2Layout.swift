//
//  InfiniteCarouselLayout.swift
//  CollectionViewFlowLayoutSamples
//
//  Created by HEssam on 11/25/25.
//

import UIKit

class InfiniteCarousel2Layout: UICollectionViewFlowLayout {
    
    private let minScale: CGFloat = 0
    
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
        
        itemSize = CGSize(width: 100, height: 100)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(
            top: 0,
            left: (collectionView.bounds.width - itemSize.width)/2,
            bottom: 0,
            right: (collectionView.bounds.width - itemSize.width)/2
        )
    }
    
//    override var collectionViewContentSize: CGSize {
//        collectionView?.bounds.size ?? .zero
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
              let collectionView else { return nil }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        for attr in attributes {
            let distance = abs(attr.center.x - centerX) // 25
            let scale = 1 - (1 - minScale) / (collectionView.bounds.width / 2) * distance
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
//                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView else { return proposedContentOffset }
//        
//        let centerX = proposedContentOffset.x + collectionView.bounds.width / 2
//        
//        guard let attributes = layoutAttributesForElements(in: collectionView.bounds) else { return proposedContentOffset }
//        guard let closest = attributes.min(by: { abs($0.center.x - centerX) < abs($1.center.x - centerX) }) else { return proposedContentOffset }
//        
//        let newOffsetX = closest.center.x - collectionView.bounds.width / 2
//        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
//    }
}
