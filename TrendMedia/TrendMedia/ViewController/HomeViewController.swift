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
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var categoryViewContainer: UIView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!
    
    var trending: [Trending] = []
    var genres: [Genre] = []
    
    var startPage = 1
    var totalResults = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trend Media"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapLeftBarButton)),
            UIBarButtonItem(image: UIImage(systemName: "map.fill"), style: .plain, target: self, action: #selector(didTapLeftLocationBarButton))
        ]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapRightButton))
        
        libraryButton.addTarget(self, action: #selector(didTapLibraryButton), for: .touchUpInside)
        
        setUpCategoryViewContainer()
        
        // API 데이터 받아오기
        fetchData()
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
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: dispatchGroup) {
            dispatchGroup.enter()
            APIManager.shared.getDailyMovieTrend(startPage: self.startPage) { response in
                self.trending.append(contentsOf: response.results)
                self.totalResults = response.totalResults
            }
            
        }
        
        DispatchQueue.global().async(group: dispatchGroup) {
            APIManager.shared.getGenre { response in
                self.genres = response.genres
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
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
        
        //vc.tvShow = tvShow
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - TableViewDataSource, Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return trending.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trending.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }

        let item = trending[indexPath.row]
        var cellGenres: [String] = []

        for movieGenreId in item.genre {
            
            for genre in self.genres {
                if genre.id == movieGenreId {
                    cellGenres.append(genre.name)
                }
            }
        }
        
        cell.poster.kf.setImage(with: URL(string: APIManager.Constants.imageBaseUrl + "\(item.posterPath ?? "")"), placeholder: nil)
        cell.title.text = item.title
        cell.date.text = item.releaseDate
        cell.genre.text = "#" + cellGenres.joined(separator: ", ")
        cell.rate.text = "인기점수: \(item.popularity)"
        cell.disclosureIcon.image = UIImage(systemName: "chevron.right")
        cell.webViewButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        cell.webViewButton.addTarget(self, action: #selector(self.didTapWebViewButton), for: .touchUpInside)
        
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
        //vc.tvShow = tvShow?[indexPath.section]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if trending.count - 1 == indexPath.row && trending.count < totalResults {
                self.startPage += 1

                fetchData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}
