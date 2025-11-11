//
//  ClockLayout.swift
//  CollectionViewFlowLayoutSamples
//
//  Created by HEssam on 11/10/25.
//

import UIKit

class ClockLayout: UICollectionViewLayout {
    
    private var clockTime = Date() // current time
    private let dateFormatter = DateFormatter() // date formatter
    
    private var timeHours = 0
    private var timeMinutes = 0
    private var timeSeconds = 0
    
    // Defines the size of clock hands and hour labels.
    var minuteHandSize = CGSize.zero
    var secondHandSize = CGSize.zero
    var hourHandSize = CGSize.zero
    var hourLabelCellSize = CGSize.zero
    
    private var clockFaceRadius: CGFloat = 0 // radius of the clock face
    private var cvCenter = CGPoint.zero // center of collection view
    
    private var attributesArray: [UICollectionViewLayoutAttributes] = [] // stores all cell positions and transformations
    
    // Called before the collection view is displayed.
    // called after collectionViewLayout.invalidateLayout() function
    override func prepare() {
        guard let collectionView else { return }
        
        // getting center of collection view
        cvCenter = CGPoint(x: collectionView.frame.size.width / 2,
                           y: collectionView.frame.size.height / 2)
        
        // current time
        clockTime = Date()
        
        dateFormatter.dateFormat = "HH"
        timeHours = Int(dateFormatter.string(from: clockTime)) ?? 0
        
        dateFormatter.dateFormat = "mm"
        timeMinutes = Int(dateFormatter.string(from: clockTime)) ?? 0
        
        dateFormatter.dateFormat = "ss"
        timeSeconds = Int(dateFormatter.string(from: clockTime)) ?? 0
        
        let minSize = min(collectionView.frame.size.width, collectionView.frame.size.height)
        clockFaceRadius = minSize / 2
        
        calculateAllAttributes()
    }
    
    // Returns the collection view size
    override var collectionViewContentSize: CGSize {
//        return collectionView?.frame.size ?? .zero
        let va = min(collectionView?.frame.size.width ?? 0, collectionView?.frame.size.height ?? 0)
        return CGSize(width: va, height: va)
    }
    
    // Returns all cell attributes for display
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    // Returns attributes for a specific cell.
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray.first { $0.indexPath == indexPath }
    }
    
    // Not used in this layout.
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    // Not used in this layout.
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    // Layout does not need to update if the bounds change.
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func calculateAllAttributes() {
        guard let collectionView else { return }
        attributesArray.removeAll()
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = calculateAttributes(for: indexPath)
                attributesArray.append(attributes)
            }
        }
    }
    
    private func calculateAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        if indexPath.section == 0 { // Section 0 → Hand cells (hour, minute, second)
            return calculateAttributesForHandCell(at: indexPath)
        } else if indexPath.section == 1 { // Section 1 → Hour label cells (numbers 1–12)
            return calculateAttributesForHourLabel(at: indexPath)
        }
        return UICollectionViewLayoutAttributes(forCellWith: indexPath) // Returns default attributes for unknown sections.
    }
    
    private func calculateAttributesForHourLabel(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = hourLabelCellSize // set size for each cell
    
        // Positions 12 labels in a circle using sine and cosine.
        let angularDisplacement = (2 * Double.pi) / 12
        let theta = angularDisplacement * Double(indexPath.row)
        
        let xDisplacement = sin(theta) * Double(clockFaceRadius - (attributes.size.width / 2))
        let yDisplacement = cos(theta) * Double(clockFaceRadius - (attributes.size.height / 2))
        
        let xPosition = cvCenter.x + CGFloat(xDisplacement)
        let yPosition = cvCenter.y - CGFloat(yDisplacement)
        
        attributes.center = CGPoint(x: xPosition, y: yPosition)
        
        return attributes
    }
    
    private func calculateAttributesForHandCell(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let rotationPerHour = (2 * Double.pi) / 12
        let rotationPerMinute = (2 * Double.pi) / 60.0
        
        switch indexPath.row {
        case 0: // Hour hand
            attributes.size = hourHandSize
            attributes.center = cvCenter
            
            let intraHourRotationPerMinute = rotationPerHour / 60
            let currentIntraHourRotation = intraHourRotationPerMinute * Double(timeMinutes)
            let angularDisplacement = (rotationPerHour * Double(timeHours)) + currentIntraHourRotation
            
            attributes.transform = CGAffineTransform(rotationAngle: CGFloat(angularDisplacement))
            
        case 1: // Minute hand
            attributes.size = minuteHandSize
            attributes.center = cvCenter
            
            let intraMinuteRotationPerSecond = rotationPerMinute / 60
            let currentIntraMinuteRotation = intraMinuteRotationPerSecond * Double(timeSeconds)
            let angularDisplacement = (rotationPerMinute * Double(timeMinutes)) + currentIntraMinuteRotation
            
            attributes.transform = CGAffineTransform(rotationAngle: CGFloat(angularDisplacement))
            
        case 2: // Second hand
            attributes.size = secondHandSize
            attributes.center = cvCenter
            
            let angularDisplacement = rotationPerMinute * Double(timeSeconds)
            attributes.transform = CGAffineTransform(rotationAngle: CGFloat(angularDisplacement))
            
        default:
            break
        }
        
        return attributes
    }
}
