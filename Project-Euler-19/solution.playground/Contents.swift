
class Date: CustomStringConvertible {
    enum DOTW: Int {
        case Sunday = 0
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        
        mutating func increment() {
            self = DOTW(rawValue: (self.rawValue + 1) % 7)!
        }
    }
    
    var description: String {
        return "\(month)/\(day)/\(year)"
    }
    
    var year: Int
    var month: Int
    var day: Int
    var dotw: DOTW
    var isLeapYear: Bool {
        if year % 400 == 0 {
            return true
        } else {
            return year % 4 == 0 && year % 100 != 0
        }
    }
    
    var daysInMonth: Int {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]
        return (month == 1 && isLeapYear) ? days : (days - 1)
    }
    
    
    init(day: Int, month: Int, year: Int, dotw: DOTW) {
        self.year = year
        self.month = month
        self.day = day
        self.dotw = dotw
    }
    
    func incrementByWeek() {
        day = day + 7
        if day > daysInMonth {
            day = (day % daysInMonth) - 1
            month = ((month + 1) % 12)
            year = (month == 0) ? year + 1 : year
        }
    }
    
    func increment() {
        day = (day == daysInMonth) ? 0 : day + 1
        month = (day == 0) ? ((month + 1) % 12) : month
        year = (day == 0 && month == 0) ? year + 1 : year
        dotw.increment()
    }
}

let today = Date.init(day: 0, month: 0, year: 1901, dotw: .Tuesday)
var count = 0
while today.year <= 2000 {
    if today.day == 0 && today.dotw == .Tuesday {
        count += 1
    }
    
    today.incrementByWeek()
}


print(count)



