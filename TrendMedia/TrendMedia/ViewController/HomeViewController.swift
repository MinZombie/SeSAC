//
//  ViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/15.
//

/*
 ----할 것----
 0. 에셋파일에 있는 이미지 제대로 적용하기 -> 안해도됌
 1. 스토리보드로 구현한 UI 설정들 코드로 설정하기
 2. 상수 따로 작성하기
 3. 중복되는 코드 지우기
 4. 주소 표시 -> 구현함
 
 ----모르는 것----
 1. 홈뷰컨트롤러에서 뷰 2개 겹치는 방법 -> 뷰 안에 뷰 2개 -> 해결
 */

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryViewContainer: UIView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    
    var tvShow: [TvShow] = dummydata
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trend Media"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapLeftBarButton)),
            UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .plain, target: self, action: #selector(didTapLeftLocationBarButton))
        ]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapRightButton))
        
        libraryButton.addTarget(self, action: #selector(didTapLibraryButton), for: .touchUpInside)
        
        setUpCategoryViewContainer()
        
    }

    
    // MARK: - Private
    private func setUpCategoryViewContainer() {
        categoryViewContainer.layer.cornerRadius = 12
        
        // 그림자 설정
        categoryViewContainer.layer.shadowColor = UIColor.black.cgColor
        categoryViewContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        categoryViewContainer.layer.shadowRadius = 4.0
        categoryViewContainer.layer.shadowOpacity = 0.5
    }
    
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
        
        // 셀 외부에 있는 컨텐츠는 값 전달을 어떻게 할까? -> Tag 활용
        
        self.present(navVC, animated: true)
    }
    
    
    @objc func didTapLeftLocationBarButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Category 버튼
    @objc func didTapLibraryButton() {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        
        vc.tvShow = tvShow
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        return (UIScreen.main.bounds.size.height / 1.2) - navigationHeight! - categoryViewContainer.frame.size.height
        
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
