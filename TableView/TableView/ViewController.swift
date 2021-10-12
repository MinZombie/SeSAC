//
//  ViewController.swift
//  TableView
//
//  Created by 민선기 on 2021/10/12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "cell"
    let sections: [String] = ["전체 설정", "개인 설정", "기타"]
    let rows: [[String]] = [["공지사항", "실험실", "버전 정보"], ["개인/보안", "알림", "채팅", "멀티프로필"], ["고객센터/도움말"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpTitle()
        //self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")

    }
    
    private func setUpTitle() {
        titleLabel.text = "설정"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
//        view?.textLabel?.text = sections[section]
//
//        return view
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        /* iOS 14 이상 셀 구현 방법
        var content = cell.defaultContentConfiguration()

        content.text = rows[indexPath.section][indexPath.row]
        cell.contentConfiguration = content
         */
        
        // iOS 13 이하 방법
        cell.textLabel?.text = rows[indexPath.section][indexPath.row]
        
        return cell
    }
}

