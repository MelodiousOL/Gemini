//
//  ChatViewController.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/20.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var vToolBar: UIView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var navbChat: UINavigationBar!
    @IBOutlet weak var txfText: UITextField!
    @IBOutlet weak var tbvChat: UITableView!
    // MARK: - Property
    
    var messages: [ChatMessage] = []
    
    var isResponding = false
    var currentTask: URLSessionDataTask?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隱藏預設返回按鈕
        self.navigationItem.hidesBackButton = true
        
        tbvChat.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: ChatTableViewCell.identifier)
        tbvChat.delegate = self
        tbvChat.dataSource = self
        tbvChat.separatorStyle = .none
        
        // 設定 NavigationBar 隱藏底線
        navbChat.setBackgroundImage(UIImage(), for: .default)
        navbChat.shadowImage = UIImage()
        navbChat.isTranslucent = false
        
        // 設定邊框
        vToolBar.layer.borderColor = UIColor.lightGray.cgColor
        vToolBar.layer.borderWidth = 1.0
        vToolBar.layer.cornerRadius = 25.0  // 如果要圓角
        vToolBar.layer.masksToBounds = true
        
        // 監聽輸入框文字改變
        txfText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        updateSendButtonIcon() // 初始狀態
    }

    // MARK: - UI Settings

    // MARK: - IBAction
    
    // 監聽 txf 狀態改變
    @IBAction func textFieldDidChange(_ sender: Any) {
        updateSendButtonIcon()
    }
    
    // 選單按鈕
    @IBAction func BackMenu(_ sender: UIBarButtonItem) {
        print("按下")
        self.navigationController?.popViewController(animated: true)
    }
    
    // 傳送訊息
    @IBAction func sendMessage(_ sender: UIButton) {
        
        // 如果正在回覆 → 變成「中斷」
        if isResponding {
            currentTask?.cancel()
            isResponding = false
            updateSendButtonIcon()
            print("sendMessage 中斷")
            return
        }
        
        // 傳送模式
        guard let text = txfText.text, !text.isEmpty else { return }
        txfText.text = ""
        updateSendButtonIcon()
        scrollToBottom()
        print("Sending: \(text)")
        
        // 使用者訊息加入 messages
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        tbvChat.reloadData()
        
        // 進入回覆中狀態你好拗
        isResponding = true
        updateSendButtonIcon()

        // 呼叫 Gemini API
        currentTask = NetworkManager.getGeminiResponse(for: text) { [weak self] responseText in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isResponding = false
                self.updateSendButtonIcon()
                
                let geminiMessage = ChatMessage(text: responseText, isUser: false)
                self.messages.append(geminiMessage)
                self.tbvChat.reloadData()
                self.scrollToBottom()
            }
        }
    }
    // MARK: - Function
    
    // 改變傳送按鈕圖示
    private func updateSendButtonIcon() {
        if isResponding {
                // 回覆中 → 顯示中斷圖示
            btnSend.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        } else if let text = txfText.text, !text.isEmpty {
            // 有文字 → 傳送
            btnSend.setImage(UIImage(systemName: "arrowshape.up.circle.fill"), for: .normal)
        } else {
            // 無文字 → 語音
            btnSend.setImage(UIImage(systemName: "waveform.circle"), for: .normal)
        }
    }
    
    // 自動滑動至當前訊息
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tbvChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
// MARK: - Extensions

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 回傳 Cell 數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // 設計 cell 外觀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        cell.configure(with: message)
        return cell
    }
}
