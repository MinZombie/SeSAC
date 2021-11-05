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
    
    let realm = try! Realm()
    
    var dateList: Results<DateList>!
    var currentMovies = List<Movie>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        print("File URL: \(realm.configuration.fileURL!)")
        
        checkUserData()
        
        
    }
    
    private func requestWhenUserNoData() {
        Manager.shared.request(date: getYesterdayDate()) { response in
            let result = response.boxOfficeResult.dailyBoxOfficeList
            
            result.forEach {
                let movie = Movie(movieNm: $0.movieNm, id: self.getYesterdayDate())
                self.currentMovies.append(movie)
            }
            
            try! self.realm.write {
                self.realm.add(self.currentMovies)
                self.realm.add(DateList(targetDt: self.getYesterdayDate(), movies: self.currentMovies))
            }
            
            self.movieTableView.reloadData()
        }
    }
    
    private func checkUserData() {
        let tasks = realm.objects(DateList.self).sorted(byKeyPath: "targetDt", ascending: false)

        guard let latestDate = tasks.first else {
            // 데이터 없음
            requestWhenUserNoData()
            print("데이터 없다")
            return
        }
        
        if latestDate.targetDt != getYesterdayDate() {
            // 최근 데이터 없음
            requestWhenUserNoData()
            print("최근 데이터 없음")
        } else {
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
}
