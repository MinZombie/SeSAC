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
    var movie: Trending?
    var casts: [Cast] = []
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
        
        APIManager.shared.getCast(movieId: movie?.id ?? 0) { response in
            self.casts = response.cast
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.casts.count)
            }
        }
        
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
            return casts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.overviewLabel.text = movie?.overview
            cell.overviewLabel.numberOfLines = isExpanded ? 0 : 1
            cell.expandButton.setImage(
                isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
                , for: .normal)
            cell.expandButton.addTarget(self, action: #selector(didTapExpandButton(_:)), for: .touchUpInside)
            cell.expandButton.tag = indexPath.row
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
            
            let cast = casts[indexPath.row]
            
            DispatchQueue.global().async {
                guard let imageUrl = URL(string: Constants.imageBaseUrl + "\(cast.profilePath ?? "")") else { return }
                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
                
                DispatchQueue.main.async {
                    cell.textLabel?.text = cast.name
                    cell.detailTextLabel?.text = cast.character
                    cell.imageView?.image = UIImage(data: imageData)
                }
            }
            
            cell.contentView.setNeedsDisplay()
            
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
            
            let backdropImageUrl = URL(string: Constants.imageBaseUrl + "\(movie?.backdropPath ?? "")")
            
            header.backgroundImage.kf.setImage(with: backdropImageUrl)
            //header.poster.image = UIImage(named: "squid_game")
            header.titleLabel.text = movie?.title
            
            
            
            return header
        } else {
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 280
        } else {
            return 0
        }
    }
    
}
