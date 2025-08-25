//
//  MainViewController.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/20.
//

import UIKit

protocol UpdateTitleDelegate: AnyObject {
    func didUpdateTitle(_ newTitle: String, at index: Int)
}

class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var navbHome: UINavigationBar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tbvChat: UITableView!
    
    // MARK: - Property
    
    // 資料陣列，存放每個 Cell 的標題
    var items: [String] = []

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 TableView 資料來源與代理
        tbvChat.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.identifier)
        tbvChat.dataSource = self
        tbvChat.delegate = self
        
        // 設定 NavigationBar 隱藏底線
        navbHome.setBackgroundImage(UIImage(), for: .default)
        navbHome.shadowImage = UIImage()
        navbHome.isTranslucent = false
    }

    // MARK: - UI Settings

    // MARK: - IBAction
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let chatVC = ChatViewController()
        chatVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    @IBAction func didTapBack(_ sender: UIBarButtonItem) {
        let chatVC = ChatViewController()
        chatVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    // MARK: - Function

    // MARK: - Extensions
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count  // Cell 數量等於資料陣列數量
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.lbTitle.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // TODO: 準備跳轉到子畫面
        print("點擊了 \(items[indexPath.row])")
    }
}
