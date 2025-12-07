//
//  CustomViewController.swift
//  CollectionViewFlowLayoutSamples
//
//  Created by HEssam on 11/10/25.
//

import UIKit

class CustomViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: clockLayout)
        collectionView.register(HandCell.self, forCellWithReuseIdentifier: hourCellView)
        collectionView.register(HandCell.self, forCellWithReuseIdentifier: hourHandCell)
        collectionView.register(HandCell.self, forCellWithReuseIdentifier: minsHandCell)
        collectionView.register(HandCell.self, forCellWithReuseIdentifier: secsHandCell)
        
        collectionView.setCollectionViewLayout(clockLayout, animated: false)
        
        clockLayout.hourLabelCellSize = CGSize(width: 100.0, height: 100.0)
        clockLayout.hourHandSize = CGSize(width: 10.0, height: 140.0)
        clockLayout.minuteHandSize = CGSize(width: 10.0, height: 200.0)
        clockLayout.secondHandSize = CGSize(width: 6.0, height: 200.0)

        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    private var dataSource: [[String]] = []
    
    private lazy var hourCellView = "HourCellView"
    private lazy var hourHandCell = "HourHandCell"
    private lazy var minsHandCell = "MinsHandCell"
    private lazy var secsHandCell = "SecsHandCell"
    
    private lazy var clockLayout = ClockLayout()
    private var tickTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupData()
        
        tickTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateClock),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    @objc private func updateClock() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupData() {
        let handsArray = ["hours", "minutes", "seconds"]
        let hoursArray = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
        
        dataSource = [handsArray, hoursArray]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0: // Clock hands
            switch indexPath.row {
            case 0: // Hour hand
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourHandCell, for: indexPath) as! HandCell
                configureHandCell(cell, size: clockLayout.hourHandSize, color: .black)
                return cell
            case 1: // Minute hand
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: minsHandCell, for: indexPath) as! HandCell
                configureHandCell(cell, size: clockLayout.minuteHandSize, color: .black)
                return cell
            default: // Second hand
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secsHandCell, for: indexPath) as! HandCell
                configureHandCell(cell, size: clockLayout.secondHandSize, color: .red)
                return cell
            }
            
        default: // Hour labels
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourCellView, for: indexPath) as! HandCell
            let hourText = dataSource[1][indexPath.row]
            cell.label.text = hourText
            return cell
        }
    }
    
    private func configureHandCell(_ cell: HandCell, size: CGSize, color: UIColor) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() } // Clear previous views
        let handView = UIView(frame: CGRect(origin: .zero, size: size))
        handView.backgroundColor = color
        cell.contentView.addSubview(handView)
        cell.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
    }
}

class HandCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.tag = 1000
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(white: 0, alpha: 0)
        backgroundColor = .white
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -25),
            label.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, constant: -25)
        ])
    }
}
