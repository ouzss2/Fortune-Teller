//
//  ContentView.swift
//  Fortune Teller
//
//  Created by Tekup-mac-1 on 5/11/2025.
//
//
//  ContentView.swift
//  Fortune Teller
//
//  Created by Tekup-mac-1 on 5/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var fortune: String = ""
    @State private var selectedLanguage = "English"
    @State private var isLoading = false
    private let aiService = AIService()
    
    let languages = ["English", "Français", "Español", "العربية"]
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.9), Color.black]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // App title
                HStack(spacing: 10) {
                    Text("🔮")
                        .font(.largeTitle)
                    Text("Fortune Teller")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                
                // Language selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(languages, id: \.self) { lang in
                            Button(action: {
                                selectedLanguage = lang
                            }) {
                                Text(lang)
                                    .fontWeight(selectedLanguage == lang ? .bold : .regular)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedLanguage == lang ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Crystal ball animation
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.purple.opacity(0.8), .pink.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 260, height: 260)
                        .shadow(color: .purple, radius: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                        )
                        .scaleEffect(isLoading ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isLoading)
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    } else {
                        Text(fortune)
                            .foregroundColor(.white)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .frame(height: 260)
                
                Spacer()
                
                // Predict button 🪄
                Button(action: {
                    Task {
                        isLoading = true
                        withAnimation { fortune = "" }
                        do {
                            let newFortune = try await aiService.getFortune(language: selectedLanguage)
                            withAnimation(.spring()) {
                                fortune = newFortune
                            }
                        } catch {
                            fortune = "The crystal ball is cloudy today..."
                        }
                        isLoading = false
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.title3)
                        Text("Predict My Future")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [.pink, .purple, .blue],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .cornerRadius(50)
                    .shadow(color: .purple.opacity(0.8), radius: 10, x: 0, y: 4)
                    .padding(.horizontal, 40)
                }
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
