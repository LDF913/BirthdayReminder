import UIKit

class Helper {
    
    static func strintFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    static func checkDate(date: Date) -> String {
        let today = Date()
        let birthday = date
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: today)
        let age = ageComponents.year!
        return "Turns \(age + 1)"
    }
    
    static func daysLeft(date: Date) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.month, .day], from: date)
        let nextDate = calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        
        let dateGet = calendar.dateComponents([.day], from: today, to: nextDate ?? today).day
        
        if dateGet == 366 || dateGet == 365 {
            return 0
        } else {
            return calendar.dateComponents([.day], from: today, to: nextDate ?? today).day!
        }
    }


}
