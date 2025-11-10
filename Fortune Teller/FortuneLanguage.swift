//
//  FortuneLanguage.swift
//  Fortune Teller
//
//  Created by Tekup-mac-1 on 5/11/2025.
//
enum FortuneLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case french = "Français"
    case spanish = "Español"
    case arabic = "العربية"
    
    var id: String { rawValue }
    
    var promptLanguage: String {
        switch self {
        case .english: return "English"
        case .french: return "French"
        case .spanish: return "Spanish"
        case .arabic: return "Arabic"
        }
    }
}

