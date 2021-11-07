//
//  ViewController.swift
//  DailyMovieBoxOffice
//
//  Created by 민선기 on 2021/10/26.
//

import UIKit

import Alamofire
import SwiftyJSON
import RealmSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var boxOfficeDateSearchbar: UISearchBar!
    
    let realm = try! Realm()
    
    var dateList: Results<DateList>!
    var currentMovies = List<Movie>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        boxOfficeDateSearchbar.delegate = self
        
        print("File URL: \(realm.configuration.fileURL!)")
        
        checkUserData()
        configureSearchbar()
    }
    
    private func searchDate(date: String) {
        
        let filteredMovie = realm.objects(DateList.self).filter("targetDt CONTAINS '\(date)'")
        
        
        if filteredMovie.isEmpty {
            // 데이터가 비어 있으면 그 날짜 영화 정보 가져오기
            requestWhenUserNoData(date: date)
            
        } else {
            // 있으니까 realm에서 저장돼있는 데이터 가져와서 보여주기
            currentMovies = filteredMovie.first!.movies

            movieTableView.reloadData()
        }
    }
    
    // date 파라미터 없애기
    private func requestWhenUserNoData(date: String) {
        Manager.shared.request(date: date) { response in
            let result = response.boxOfficeResult.dailyBoxOfficeList
            let temp =  List<Movie>()
            
            // 현재 테이블뷰에 보여줄 영화 저장하는 부분
            result.forEach {
                let movie = Movie(movieNm: $0.movieNm, id: date)
                temp.append(movie)
            }
            
            self.currentMovies = temp
            
            try! self.realm.write {
                self.realm.add(self.currentMovies)
                self.realm.add(DateList(targetDt: date, movies: self.currentMovies))
            }
            
            self.movieTableView.reloadData()
        }
    }
    
    private func checkUserData() {
        let tasks = realm.objects(DateList.self).sorted(byKeyPath: "targetDt", ascending: false)
        
        guard let latestDate = tasks.first else {
            // 데이터 없음
            requestWhenUserNoData(date: getYesterdayDate())
            print("데이터 없다")
            return
        }
        
        if latestDate.targetDt != getYesterdayDate() {
            // 최근 데이터 없음
            requestWhenUserNoData(date: getYesterdayDate())
            print("최근 데이터 없음")
        } else {
            // realm에 데이터 있어서 가져와서 보여주기
            print("데이터 있음")
            currentMovies = tasks.first!.movies
            movieTableView.reloadData()
        }
    }
    
    private func getYesterdayDate() -> String {
        let yesterday = Date() - 86400
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: yesterday)
        
    }
    
    private func configureSearchbar() {
        boxOfficeDateSearchbar.showsCancelButton = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = currentMovies[indexPath.row].movieNm
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespaces), text.count == 8 else {
            // Alert 보여주기
            print("글자수 8자리 아님")
            return
        }
        
        searchDate(date: text)
    }
    
    // 취소 버튼 눌렀을 때 키보드 내리기
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        boxOfficeDateSearchbar.text = ""
        searchBar.resignFirstResponder()
    }
    
}
