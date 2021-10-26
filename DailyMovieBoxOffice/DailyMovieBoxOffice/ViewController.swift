//
//  ViewController.swift
//  DailyMovieBoxOffice
//
//  Created by 민선기 on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var baseUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    
    var titles: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        request()
    }

    private func request() {
        let url = baseUrl + "key=\(API_KEY)&targetDt=\(getYesterdayDate())"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let result):
                let json = JSON(result)
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    self.titles.append(item["movieNm"].stringValue)
                }
                
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
    }
}
