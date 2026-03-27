//
//  GreetingProvider.swift
//  Wiser
//
//  Created by Marlin on 27/03/2026.
//

import SwiftUI
import WeatherKit
import CoreLocation

@Observable
final class GreetingProvider {
    private(set) var sunrise: Date?
    private(set) var sunset: Date?
    private(set) var weatherSymbol: String?
    private let weatherService = WeatherService.shared

    var greeting: String {
        let now = Date()
        guard let sunrise, let sunset else {
            return fallbackGreeting
        }

        let calendar = Calendar.current
        let dawnStart = calendar.date(byAdding: .hour, value: -1, to: sunrise)!
        let morningEnd = calendar.date(byAdding: .hour, value: 0, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: now)!)!
        let duskEnd = calendar.date(byAdding: .hour, value: 1, to: sunset)!

        if now < dawnStart {
            return "Good night"
        } else if now < sunrise {
            return "Good morning"
        } else if now < morningEnd {
            return "Good morning"
        } else if now < sunset {
            return "Good afternoon"
        } else if now < duskEnd {
            return "Good evening"
        } else {
            return "Good night"
        }
    }

    // 日本の伝統色
    var greetingColor: Color {
        switch greeting {
        case "Good morning": return Color(red: 0xF1/255.0, green: 0x90/255.0, blue: 0x72/255.0)   // 曙色
        case "Good afternoon": return Color(red: 0xFF/255.0, green: 0xD9/255.0, blue: 0x00/255.0)  // 蒲公英色
        case "Good evening": return Color(red: 0xB7/255.0, green: 0x28/255.0, blue: 0x2E/255.0)    // 茜色
        case "Good night": return Color(red: 0x22/255.0, green: 0x3A/255.0, blue: 0x70/255.0)      // 紺色
        default: return .secondary
        }
    }

    var displaySymbol: String {
        if let weatherSymbol { return weatherSymbol }
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<18: return "sun.max.fill"
        default: return "moon.stars.fill"
        }
    }

    private var fallbackGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }

    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)
            if let today = weather.dailyForecast.first {
                sunrise = today.sun.sunrise
                sunset = today.sun.sunset
            }
            weatherSymbol = weather.currentWeather.symbolName
        } catch {
            print("WeatherKit error: \(error.localizedDescription)")
        }
    }
}
