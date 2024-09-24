import Foundation

class Helper {
    static func timeAgoStringToUnix(_ timeAgo: String?) -> Int64? {
        guard let timeAgo = timeAgo else {
            return nil
        }
        let now = Date()
        let calendar = Calendar.current
        let regex = try! NSRegularExpression(pattern: #"(\d+)\s(\w+)\sago"#, options: [])
        let nsRange = NSRange(timeAgo.startIndex..<timeAgo.endIndex, in: timeAgo)
        if let match = regex.firstMatch(in: timeAgo, options: [], range: nsRange) {
            let numberRange = Range(match.range(at: 1), in: timeAgo)
            let unitRange = Range(match.range(at: 2), in: timeAgo)
            guard let numberRange = numberRange, let unitRange = unitRange,
                  let number = Int(timeAgo[numberRange]) else {
                return nil
            }
            let unit = String(timeAgo[unitRange]).lowercased()
            var dateComponent = DateComponents()
            switch unit {
            case "second", "seconds":
                dateComponent.second = -number
            case "minute", "minutes":
                dateComponent.minute = -number
            case "hour", "hours":
                dateComponent.hour = -number
            case "day", "days":
                dateComponent.day = -number
            case "week", "weeks":
                dateComponent.day = -number * 7
            case "month", "months":
                dateComponent.month = -number
            case "year", "years":
                dateComponent.year = -number
            default:
                return nil
            }
            if let pastDate = calendar.date(byAdding: dateComponent, to: now) {
                let unixTime = Int(pastDate.timeIntervalSince1970)
                return Int64(unixTime)
            }
        }
        return nil
    }
    
    static func timeAgo(from timestamp: Int64) -> String {
        let currentDate = Date()
        let timestampDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: timestampDate, to: currentDate)
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }
        if let seconds = components.second, seconds > 0 {
            return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
        }
        return "Just now"
    }

    static func timeStringToSeconds(_ timeString: String?) -> Int? {
        guard let timeString = timeString else {
            return nil
        }
        let components = timeString.split(separator: ":").map { Int($0) }
        guard components.allSatisfy({ $0 != nil }) else {
            return nil
        }
        let timeComponents = components.compactMap { $0 }
        switch timeComponents.count {
        case 2: // Format is "MM:SS"
            let minutes = timeComponents[0]
            let seconds = timeComponents[1]
            return (minutes * 60) + seconds
        case 3: // Format is "HH:MM:SS"
            let hours = timeComponents[0]
            let minutes = timeComponents[1]
            let seconds = timeComponents[2]
            return (hours * 3600) + (minutes * 60) + seconds
        default: // Invalid format
            return nil
        }
    }
}
