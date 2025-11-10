//
//  AIService.swift
//  Fortune Teller
//
//  Created by Tekup-mac-1 on 5/11/2025.
//

import Foundation

class AIService {
    
    private let apiKey = "AIzaSyBy1H3Zncs5X5rcVhgVxrlAyxUdT1R6Pck"
    
    func getFortune(language: String) async throws -> String {
        // Choose model endpoint (Gemini 1.5 Flash is free)
        guard let endpoint = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        // Create language-specific prompt
        let prompt: String
        switch language {
        case "Français":
            prompt = "Agis comme une voyante drôle. Génère une prédiction courte et absurde en français."
        case "Español":
            prompt = "Actúa como un adivino gracioso. Genera una predicción corta y absurda en español."
        case "العربية":
            prompt = "تصرّف كأنك عرّاف مضحك. أنشئ تنبؤًا قصيرًا وسخيفًا باللغة العربية."
        default:
            prompt = "Act as a funny fortune teller. Generate one short, absurd, funny prediction in English."
        }
        
        // Request body
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        
        // Prepare request
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Perform request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode response
        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return decoded.candidates.first?.content.parts.first?.text ?? "The spirits are silent..."
    }
}

// MARK: - GeminiResponse
struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}
