//
//  NetworkManager.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/26.
//
// AIzaSyCOiNuVpdjXcDCE0dmYVcsqjZT6HkluZbE

import Foundation

class NetworkManager {
    
    static let apiKey = "AIzaSyCOiNuVpdjXcDCE0dmYVcsqjZT6HkluZbE"
    
    @discardableResult
    static func getGeminiResponse(for userInput: String, completion: @escaping (String) -> Void) -> URLSessionDataTask {
        
        let modelName = "gemini-1.5-flash"
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion("URL 錯誤")
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": userInput
                        ]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            completion("JSON 轉換失敗")
            fatalError("Invalid JSON")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error as NSError? {
                if error.code == NSURLErrorCancelled {
                    // 使用者中斷
                    print("使用者中斷 Gemini 回覆")
                    completion("回覆已取消")
                    return
                } else {
                    // 其他錯誤
                    print("請求錯誤: \(error)")
                    completion("網路錯誤")
                    return
                }
            }

            guard let data = data else {
                completion("沒有回傳資料")
                return
            }
            
            do {
                let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
                let text = geminiResponse.candidates?.first?.content.parts.first?.text ?? "沒有回覆"
                completion(text)
            } catch {
                print("JSON 解析錯誤: \(error)")
                completion("解析錯誤")
            }
        }
        
        task.resume()
        return task
    }
}
