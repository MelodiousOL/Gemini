//
//  NetworkManager.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/26.
//
// AIzaSyCOiNuVpdjXcDCE0dmYVcsqjZT6HkluZbE

import Foundation

class NetworkManager {
    
    // API 金鑰
    static let apiKey = "AIzaSyCOiNuVpdjXcDCE0dmYVcsqjZT6HkluZbE"
    
    // 向 Gemini API 發送請求並處理回傳結果
    static func getGeminiResponse(for userInput: String, completion: @escaping (String) -> Void) {
        
        // 選擇模型
        let modelName = "gemini-1.5-flash"
        
        // URL 格式
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion("URL 錯誤")
            return
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
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("請求錯誤: \(error)")
                completion("網路錯誤")
                return
            }
            
            guard let data = data else {
                completion("沒有回傳資料")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("伺服器錯誤: \(httpResponse.statusCode), 訊息: \(responseString)")
                }
                completion("伺服器回傳錯誤狀態碼 \(httpResponse.statusCode)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let geminiResponse = try decoder.decode(GeminiResponse.self, from: data)
                
                if let generatedText = geminiResponse.candidates?.first?.content.parts.first?.text {
                    completion(generatedText)
                } else {
                    completion("沒有回覆內容或解析失敗")
                }
                
            } catch {
                print("JSON 解析錯誤: \(error)")
                completion("解析錯誤")
            }
        }

        task.resume()
    }
}
