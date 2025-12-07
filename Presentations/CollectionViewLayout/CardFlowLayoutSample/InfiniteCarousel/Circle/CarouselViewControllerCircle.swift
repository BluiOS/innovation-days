//
//  CarouselViewControllerCircle.swift
//  CardFlowLayoutSample
//
//  Created by Ali Shafiee on 9/10/1404 AP.
//

import UIKit

class CarouselViewControllerCircle: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow]
    
    private lazy var layout: InfiniteCarouselCircleLayout = {
        let l = InfiniteCarouselCircleLayout()
        l.itemSize = CGSize(width: 50, height: 50)
        return l
    }()
    
    private let repeatCount = 3000
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CircleCell.self, forCellWithReuseIdentifier: "CircleCell")
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carousel Layout"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let mid = (self.colors.count * self.repeatCount) / 2
            self.collectionView.scrollToItem(at: IndexPath(item: mid, section: 0),
                                             at: .centeredHorizontally,
                                             animated: false)
        }
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return colors.count * repeatCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCell", for: indexPath)
        let realIndex = indexPath.item % colors.count
        cell.backgroundColor = colors[realIndex]
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToNearestCell()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearestCell()
    }
    
    private func snapToNearestCell() {
        guard let layout = collectionView.collectionViewLayout as? InfiniteCarouselCircleLayout else { return }
        guard let attributes = layout.layoutAttributesForElements(in: collectionView.bounds) else { return }
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let closest = attributes.min(by: { abs($0.center.x - centerX) < abs($1.center.x - centerX) })
        guard let closestAttr = closest else { return }
        collectionView.scrollToItem(at: closestAttr.indexPath, at: .centeredHorizontally, animated: true)
    }
}

class CircleCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
