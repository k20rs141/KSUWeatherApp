import Foundation

extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter.string(from: self)
    }
    
    func formatAsToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
    
    func formatAsdays() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d E"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
}
