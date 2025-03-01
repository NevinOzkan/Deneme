//
//  Network.swift
//  Deneme
//
//  Created by Nevin Özkan on 26.02.2025.
//

import Foundation

class TextGenerator {
    private var accumulatedResponse: String = ""

    func generateText(prompt: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "http://127.0.0.1:11434/api/generate")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "prompt": prompt,
            "model": "mistral:latest",
            "stream": true,
            "max_tokens": 500,
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let responseText = String(data: data, encoding: .utf8) else {
                print("Veri alınamadı.")
                completion(nil)
                return
            }

            let lines = responseText.split(separator: "\n")

            for line in lines {
                if let jsonData = line.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let responsePart = json["response"] as? String {
                    
                    self?.accumulatedResponse += responsePart
                }
            }

            completion(self?.accumulatedResponse)
            self?.accumulatedResponse = ""
        }

        task.resume()
    }
    
    func generateStory(completion: @escaping (String?) -> Void) {
        let storyPrompt = """
Bana güzel, öğretici ve akıcı bir çocuk masalı yaz.  
Masalın başında Arjin ve Ayza kardeşlerinden bahset, ortasında bir macera yaşat ve sonunda ders verici bir sonuçla bitir.  
Kelimeler düzgün ve anlaşılır olsun, hikaye mantıklı ilerlesin. Cümleler tutarlı ve akıcı olsun.
"""
        
        generateText(prompt: storyPrompt, completion: completion)
    }
}
