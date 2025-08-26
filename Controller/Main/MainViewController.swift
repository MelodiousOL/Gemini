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
    
    @IBOutlet weak var tbvMenu: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定 TableView 資料來源與代理
        tbvMenu.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.identifier)
        tbvMenu.dataSource = self
        tbvMenu.delegate = self

        tbvMenu.layer.cornerRadius = 8.0 // 圓角
        tbvMenu.isScrollEnabled = false  // 禁止滑動
        tbvMenu.separatorStyle = .none // 隱藏分隔線

    }

    // MARK: - UI Settings

    // MARK: - IBAction
    
    // MARK: - Function

    // MARK: - Extensions
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    // 設定 cell 數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 設計 cell 外觀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.textLabel?.text = "Chat" // cell 文字
        cell.imageView?.image = UIImage(systemName: "ellipsis.message.fill") // cell 圖示
        cell.imageView?.tintColor = .systemBlue // cell 圖示顏色
        cell.accessoryType = .disclosureIndicator // 顯示右側灰色箭頭
        return cell
    }
    
    // 設計 cell 點擊事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 點擊 Cell 跳轉到 ChatViewController
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController()
        chatVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
