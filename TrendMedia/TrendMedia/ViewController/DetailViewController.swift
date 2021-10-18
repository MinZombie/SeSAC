//
//  DetailViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/16.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var tvShow: TvShow?
    var actors: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "출연/제작"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: DetailTableHeaderFooterView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: DetailTableHeaderFooterView.identifier)
        
        getActors(data: tvShow?.starring ?? "")
    }
    
    // 배우들 데이터가 배열에 담겨있지 않고 문자열 하나에 다 담겨 있어서, 배열로 바로 바꾸는 함수
    func getActors(data: String) {
        self.actors = data.components(separatedBy: ", ")
    }

}

// MARK: - UITableViewDataSource, Delegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = actors[indexPath.row]
        cell.imageView?.image = UIImage(named: "squid_game")
        
        return cell
    }
    
    
    // MARK: - Table header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTableHeaderFooterView.identifier) as? DetailTableHeaderFooterView else {
            return UITableViewHeaderFooterView()
        }
        
        let url = URL(string: tvShow?.backdropImage ?? "")
        
        header.backgroundImage.kf.setImage(with: url)
        header.poster.image = UIImage(named: "squid_game")
        header.titleLabel.text = tvShow?.title
        
        
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    
}
