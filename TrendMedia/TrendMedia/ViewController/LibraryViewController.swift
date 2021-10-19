//
//  LibraryViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/19.
//

import UIKit

class LibraryViewController: UIViewController {
    
    var tvShow: [TvShow]?
    
    @IBOutlet weak var libraryCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        let nib = UINib(nibName: "LibraryCollectionViewCell", bundle: nil)
        libraryCollectionView.register(nib, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        
        libraryCollectionView.dataSource = self
        libraryCollectionView.delegate = self
        
        // 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 3)
        let height = UIScreen.main.bounds.height - (spacing * 5)
        
        layout.itemSize = CGSize(width: width / 2, height: height / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        libraryCollectionView.collectionViewLayout = layout
    }
}

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShow?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = tvShow?[indexPath.item]
        
        cell.titleLabel.text = item?.title
        cell.rate.text = "\(item?.rate ?? 0)"
        cell.poster.image = UIImage(named: "squid_game")
        
        
        return cell
    }
    
    
}
