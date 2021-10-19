//
//  DetailViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/16.
//

import UIKit
import Kingfisher

fileprivate enum Section: Int {
    case zero, one
}

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var tvShow: TvShow?
    var actors: [String] = []
    var isExpanded: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "출연/제작"
        
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: DetailTableHeaderFooterView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: DetailTableHeaderFooterView.identifier)
        tableView.register(UINib(nibName: OverviewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.identifier)
        
        getActors(data: tvShow?.starring ?? "")
    }
    
    // 배우들 데이터가 배열에 담겨있지 않고 문자열 하나에 다 담겨 있어서, 배열로 바로 바꾸는 함수
    func getActors(data: String) {
        self.actors = data.components(separatedBy: ", ")
    }
    
    @objc func didTapExpandButton(_ sender: UIButton) {
        isExpanded = !isExpanded
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        
    }

}

// MARK: - UITableViewDataSource, Delegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return actors.count
        }
        
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.overviewLabel.text = tvShow?.overview
            cell.overviewLabel.numberOfLines = isExpanded ? 0 : 1
            cell.expandButton.setImage(
                isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
                , for: .normal)
            cell.expandButton.addTarget(self, action: #selector(didTapExpandButton(_:)), for: .touchUpInside)
            cell.expandButton.tag = indexPath.row
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
            
            cell.textLabel?.text = actors[indexPath.row]
            cell.imageView?.image = UIImage(named: "squid_game")
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Table header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailTableHeaderFooterView.identifier) as? DetailTableHeaderFooterView else {
                return UITableViewHeaderFooterView()
            }
            
            let url = URL(string: tvShow?.backdropImage ?? "")
            
            header.backgroundImage.kf.setImage(with: url)
            header.poster.image = UIImage(named: "squid_game")
            header.titleLabel.text = tvShow?.title
            
            
            
            return header
        } else {
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return 0
        }
    }
    
}
