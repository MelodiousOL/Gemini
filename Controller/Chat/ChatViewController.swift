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

    @IBAction func textFieldDidChange(_ sender: Any) {
        updateSendButtonIcon()
    }
    
    @IBAction func BackMenu(_ sender: UIBarButtonItem) {
        print("按下")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = txfText.text, !text.isEmpty else { return }
        // 執行送訊息邏輯
        txfText.text = ""
        print("Sending: \(text)")
        
        // 1. 使用者訊息加入 messages
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        tbvChat.reloadData()

        // 2. 呼叫 Gemini API 模擬回應
        getGeminiResponse(for: text)
    }
    // MARK: - Function
    
    // 改變傳送按鈕圖示
    private func updateSendButtonIcon() {
        if let text = txfText.text, !text.isEmpty {
            // 有文字 → 顯示傳送圖示
            btnSend.setImage(UIImage(systemName: "arrowshape.up.circle.fill"), for: .normal)
        } else {
            // 沒文字 → 顯示語音圖示
            btnSend.setImage(UIImage(systemName: "waveform.circle"), for: .normal)
        }
    }
    
    func getGeminiResponse(for userInput: String) {
        // 模擬 Gemini 回答（之後會接 API）
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let geminiMessage = ChatMessage(text: "這是 Gemini 對「\(userInput)」的回應", isUser: false)
            self.messages.append(geminiMessage)
            self.tbvChat.reloadData()
        }
    }
}
// MARK: - Extensions

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        cell.configure(with: message)
        return cell
    }
}
