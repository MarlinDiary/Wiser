//
//  GreetingProvider.swift
//  Wiser
//
//  Created by Marlin on 27/03/2026.
//

import SwiftUI
import WeatherKit
import CoreLocation

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

@Observable
final class GreetingProvider {
    private(set) var sunrise: Date?
    private(set) var sunset: Date?
    private(set) var weatherSymbol: String?
    private let weatherService = WeatherService.shared

    private let defaults = UserDefaults.standard
    private enum Keys {
        static let weatherSymbol = "GreetingProvider.weatherSymbol"
        static let lastFetchDate = "GreetingProvider.lastFetchDate"
    }

    private var refreshInterval: TimeInterval { 30 * 60 } // 30 minutes

    private var overrideGreeting: String?

    init() {
        weatherSymbol = defaults.string(forKey: Keys.weatherSymbol)
    }

    init(preview greeting: String, symbol: String) {
        overrideGreeting = greeting
        weatherSymbol = symbol
    }

    var greeting: String {
        if let overrideGreeting { return overrideGreeting }
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

    // 日本の伝統色（亮色/暗色适配）
    var greetingColor: Color {
        Color(light: lightColor, dark: darkColor)
    }

    private var lightColor: Color {
        switch greeting {
        case "Good morning": return Color(red: 0xF1/255.0, green: 0x90/255.0, blue: 0x72/255.0)   // 曙色
        case "Good afternoon": return Color(red: 0xE6/255.0, green: 0xB4/255.0, blue: 0x22/255.0)  // 山吹色
        case "Good evening": return Color(red: 0x86/255.0, green: 0x7B/255.0, blue: 0xA9/255.0)    // 紫苑色
        case "Good night": return Color(red: 0x22/255.0, green: 0x3A/255.0, blue: 0x70/255.0)      // 紺色
        default: return .secondary
        }
    }

    private var darkColor: Color {
        switch greeting {
        case "Good morning": return Color(red: 0xF7/255.0, green: 0xB2/255.0, blue: 0x9B/255.0)   // 淡曙色
        case "Good afternoon": return Color(red: 0xF5/255.0, green: 0xD0/255.0, blue: 0x62/255.0)  // 淡山吹色
        case "Good evening": return Color(red: 0xB0/255.0, green: 0xA7/255.0, blue: 0xCC/255.0)    // 淡紫苑色
        case "Good night": return Color(red: 0x6B/255.0, green: 0x8E/255.0, blue: 0xC2/255.0)      // 淡紺色
        default: return .secondary
        }
    }

    var displaySymbol: String {
        if let weatherSymbol { return weatherSymbol }
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<18: return "sun.max"
        default: return "moon.stars"
        }
    }

    var needsRefresh: Bool {
        guard let lastFetch = defaults.object(forKey: Keys.lastFetchDate) as? Date else {
            return true
        }
        return Date().timeIntervalSince(lastFetch) > refreshInterval
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
            withAnimation(.easeInOut(duration: 0.5)) {
                weatherSymbol = weather.currentWeather.symbolName
            }
            defaults.set(weatherSymbol, forKey: Keys.weatherSymbol)
            defaults.set(Date(), forKey: Keys.lastFetchDate)
        } catch {
            print("WeatherKit error: \(error.localizedDescription)")
        }
    }
}
