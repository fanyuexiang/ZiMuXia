//
//  ZMCollectionViewController.swift
//  ZiMu
//
//  Created by fancy on 2018/4/4.
//  Copyright © 2018年 Fancy. All rights reserved.
//

import UIKit

final class ZMCollectionViewController: ZMViewController {

    // UI
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = ZJFlexibleLayout(delegate: self)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ZMMovieCollectionViewCell.self, forCellWithReuseIdentifier: ZMMovieCollectionViewCell.CellIdentifier)
        collectionView.register(ZMCollectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ZMCollectionHeader.CellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // data
    fileprivate lazy var movies: [ZMMovie] = {
        if let movies = ZMMovie.objectsWhere(nil, arguments: nil) as? [ZMMovie] {
            return movies
        }
        return [ZMMovie]()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCollectionView()
    }

    override func initSubviews() {
        super.initSubviews()
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    private func refreshCollectionView() {
        if movies.count != 0 {
            collectionView.reloadData()
        } else {
            showEmptyView(withText: "这里是空的啊!!", detailText: "去看看有什么电影", buttonTitle: nil, buttonAction: nil)
        }
    }
    
}


// MARK: - ZJFlexibleDataSource
extension ZMCollectionViewController: ZJFlexibleDataSource {
    func numberOfCols(at section: Int) -> Int {
        return 2
    }
    
    func sizeOfItemAtIndexPath(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140.adapted, height: 260.adapted)
    }
    
    func spaceOfCells(at section: Int) -> CGFloat {
        return 20.adapted
    }
    
    func heightOfAdditionalContent(at indexPath: IndexPath) -> CGFloat {
        return 10.adapted
    }
    
    func sizeOfHeader(at section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func sectionInsets(at section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.adapted, left: 15.adapted, bottom: 10.adapted, right: 15.adapted)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ZMCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZMMovieCollectionViewCell.CellIdentifier, for: indexPath) as! ZMMovieCollectionViewCell
        let data = movies[indexPath.item]
        cell.setupCell(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = movies[indexPath.item]
        if let url = data.homepageUrl {
            let detailVC = ZMMovieDetailViewController(url: url, movie: data)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZMMovieCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ZMMovieCollectionViewCell
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}
