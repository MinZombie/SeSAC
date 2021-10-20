//
//  WebViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/18.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var tvShowTitle: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var fowardButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        setUpButton()
    }
    
    private func setUpButton() {
        reloadButton.action = #selector(didTapReloadButton)
        reloadButton.target = self
        
        backButton.action = #selector(didTapBackButton)
        backButton.target = self
        
        fowardButton.action = #selector(didTapFowardButton)
        fowardButton.target = self
    }
    
    @objc func didTapReloadButton() {
        webView.reload()
    }
    
    @objc func didTapBackButton() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func didTapFowardButton() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
}

extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let url = URL(string: searchBar.text ?? "") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
