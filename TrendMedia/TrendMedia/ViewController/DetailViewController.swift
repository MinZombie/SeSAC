//
//  DetailViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/16.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "출연/제작"
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath)
        
        cell.textLabel?.text = "name"
        cell.detailTextLabel?.text = "name"
       
        
        return cell
    }
}
