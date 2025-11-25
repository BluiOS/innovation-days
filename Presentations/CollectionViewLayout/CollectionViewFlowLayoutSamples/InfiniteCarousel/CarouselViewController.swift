//
//  CarouselViewController.swift
//  CollectionViewFlowLayoutSamples
//
//  Created by HEssam on 11/25/25.
//

import UIKit

class CarouselViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow]
    
    private lazy var layout: InfinitePagedCarouselLayout = {
        let l = InfinitePagedCarouselLayout()
        l.itemSize = CGSize(width: 260, height: 350)
        return l
    }()
    
    private lazy var layout2: InfiniteCarousel2Layout = {
        let l = InfiniteCarousel2Layout()
        l.itemSize = CGSize(width: 100, height: 100)
        return l
    }()
    
    private let repeatCount = 3000
    
//    private lazy var collectionView: UICollectionView = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
//        cv.dataSource = self
//        cv.delegate = self
//        cv.showsHorizontalScrollIndicator = false
//        cv.backgroundColor = .clear
//        return cv
//    }()
    
    private lazy var collectionView2: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
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
        
        view.addSubview(collectionView2)
        collectionView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            collectionView2.heightAnchor.constraint(equalToConstant: 400),
            collectionView2.heightAnchor.constraint(equalToConstant: 100),
            collectionView2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView2.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let mid = (self.colors.count * self.repeatCount) / 2
            self.collectionView2.scrollToItem(at: IndexPath(item: mid, section: 0),
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
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
        guard let layout = collectionView2.collectionViewLayout as? InfiniteCarousel2Layout else { return }
        guard let attributes = layout.layoutAttributesForElements(in: collectionView2.bounds) else { return }

        let centerX = collectionView2.contentOffset.x + collectionView2.bounds.width / 2

        let closest = attributes.min(by: { abs($0.center.x - centerX) < abs($1.center.x - centerX) })
        guard let closestAttr = closest else { return }

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.collectionView2.contentOffset.x = closestAttr.center.x - self.collectionView2.bounds.width / 2
        }, completion: nil)
    }
}

class ColorCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.cornerRadius = 25
        layer.cornerRadius = 50
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
