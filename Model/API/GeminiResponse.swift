//
//  GeminiResponse.swift
//  Gemini
//
//  Created by 黃盈雅 on 2025/8/26.
//

import Foundation

// MARK: - GeminiResponse
/// 代表整個 Gemini API 的回應物件。
struct GeminiResponse: Decodable {
    /// 包含一個或多個生成內容的候選物件陣列。
    let candidates: [Candidate]?
    
    // 您可以在此處新增其他頂層屬性，例如 'promptFeedback'。
    // let promptFeedback: PromptFeedback?
}

// MARK: - Candidate
/// 代表一個單獨的生成結果。
struct Candidate: Decodable {
    /// 包含由模型生成的實際內容。
    let content: Content
    
    /// 說明生成過程為何結束的理由（例如 "STOP" 或 "SAFETY"）。
    let finishReason: String?
    
    // 您也可以新增 "safetyRatings" 屬性來處理安全評分。
    // let safetyRatings: [SafetyRating]?
}

// MARK: - Content
/// 包含由模型生成的內容細節。
struct Content: Decodable {
    /// 內容的角色，通常為 "model"。
    let role: String?
    
    /// 內容的部分，通常包含文字。
    let parts: [Part]
}

// MARK: - Part
/// 代表內容的單個部分。
struct Part: Decodable {
    /// 生成的純文字內容。如果內容是文字，此欄位會存在。
    let text: String?
    
    // 如果您需要處理圖片或其他多媒體內容，可以在此處新增 'inlineData'。
    // let inlineData: InlineData?
}

/*
以下是一個範例 JSON 回應，與上述結構相對應：

{
  "candidates": [
    {
      "content": {
        "role": "model",
        "parts": [
          {
            "text": "您好！很高興能幫助您。"
          }
        ]
      },
      "finishReason": "STOP",
      "safetyRatings": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "probability": "NEGLIGIBLE"
        },
        // ... 其他安全評分
      ]
    }
  ],
  "promptFeedback": {
    "safetyRatings": [
      // ... 提示的安全評分
    ]
  }
}
*/
