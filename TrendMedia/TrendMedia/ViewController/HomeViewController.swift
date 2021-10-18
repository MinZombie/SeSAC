//
//  ViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tvShow: [TvShow] = dummydata
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapLeftBarButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapRightButton))
        
    }
    
    // MARK: - Private
//    private func getImageName(name: String) -> String {
//        let pattern = " -':&"
//        let range = pattern.startIndex..<pattern.index(before: pattern.endIndex)
//        return name.replacingCharacters(in: range, with: "-")
//    }
    
    // MARK: - @objc
    @objc func didTapLeftBarButton() {
        
    }
    
    @objc func didTapRightButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func didTapWebViewButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let navVC = UINavigationController(rootViewController: vc)
        
        // 셀 외부에 있는 컨텐츠는 값 전달을 어떻게 할까?
        vc.tvShowTitle = "babo"
        
        self.present(navVC, animated: true)
    }
    
}

// MARK: - TableViewDataSource, Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tvShow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        
        let item = tvShow[indexPath.section]
        
        cell.poster.image = UIImage(named: "squid_game")
        cell.title.text = item.title
        cell.date.text = item.releaseDate
        cell.genre.text = "# " + item.genre
        cell.rate.text = "평점: \(item.rate)"
        cell.disclosureIcon.image = UIImage(systemName: "chevron.right")
        cell.webViewButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        cell.webViewButton.addTarget(self, action: #selector(didTapWebViewButton), for: .touchUpInside)

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let navigationHeight = self.navigationController?.navigationBar.frame.size.height
        return UIScreen.main.bounds.size.height - CGFloat(navigationHeight!) - view.layoutMargins.top
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // DetailViewController 데이터 넘겨주는 부분
        vc.tvShow = tvShow[indexPath.section]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 스크롤할 때 애니메이션 조금
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
            cell.alpha = 1.0
        }
    }
}
