//
//  ChatTableViewCell.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/26.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet weak var vbubble: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    // MARK: - Property
    
    static let identifier = "ChatTableViewCell"

    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vbubble.layer.cornerRadius = 12
        vbubble.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - UI Settings

    // MARK: - IBAction

    // MARK: - Function
    
    func configure(with message: ChatMessage) {
        lbMessage.text = message.text
        if message.isUser {
            // 使用者訊息 → 靠右
//            lbMessage.textColor = .black
            lbMessage.textAlignment = .right
        } else {
            // Gemini 訊息 → 靠左
//            lbMessage.textColor = .black
            lbMessage.textAlignment = .left
        }
    }

    // MARK: - Extensions
}
