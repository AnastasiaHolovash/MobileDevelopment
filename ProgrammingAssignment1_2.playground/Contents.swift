
import Foundation

// Частина 1

// Дано рядок у форматі "Student1 - Group1; Student2 - Group2; ..."

let studentsStr = "Дмитренко Олександр - ІП-84; Матвійчук Андрій - ІВ-83; Лесик Сергій - ІО-82; Ткаченко Ярослав - ІВ-83; Аверкова Анастасія - ІО-83; Соловйов Даніїл - ІО-83; Рахуба Вероніка - ІО-81; Кочерук Давид - ІВ-83; Лихацька Юлія - ІВ-82; Головенець Руслан - ІВ-83; Ющенко Андрій - ІО-82; Мінченко Володимир - ІП-83; Мартинюк Назар - ІО-82; Базова Лідія - ІВ-81; Снігурець Олег - ІВ-81; Роман Олександр - ІО-82; Дудка Максим - ІО-81; Кулініч Віталій - ІВ-81; Жуков Михайло - ІП-83; Грабко Михайло - ІВ-81; Іванов Володимир - ІО-81; Востриков Нікіта - ІО-82; Бондаренко Максим - ІВ-83; Скрипченко Володимир - ІВ-82; Кобук Назар - ІО-81; Дровнін Павло - ІВ-83; Тарасенко Юлія - ІО-82; Дрозд Світлана - ІВ-81; Фещенко Кирил - ІО-82; Крамар Віктор - ІО-83; Іванов Дмитро - ІВ-82"

// Завдання 1
// Заповніть словник, де:
// - ключ – назва групи
// - значення – відсортований масив студентів, які відносяться до відповідної групи

var studentsGroups: [String: [String]] = [:]

// Ваш код починається тут

// Створення масиву з елементами у форматі "Student1 - Group1"
let studentsArray = studentsStr.components(separatedBy: ";")

studentsArray.forEach { student in
    // Масив типу ["Student1", "Group1"]
    let studentArray = student
        .replacingOccurrences(of: " - ", with: "v", options: .literal)
        .trimmingCharacters(in: .whitespaces)
        .components(separatedBy: "v")
    
    // Якщо уже була додана така група до словника
    if var arrayForGroup = studentsGroups[studentArray[1]] {
        arrayForGroup.append(studentArray[0])
        studentsGroups[studentArray[1]] = arrayForGroup
    } else {
        // Якщо такої групи ще немає у словнику
        studentsGroups[studentArray[1]] = [studentArray[0]]
    }
}

// Ваш код закінчується тут

print("Завдання 1")
print(studentsGroups)
print()

// Дано масив з максимально можливими оцінками

let points: [Int] = [12, 12, 12, 12, 12, 12, 12, 16]

// Завдання 2
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – масив з оцінками студента (заповніть масив випадковими значеннями, використовуючи функцію `randomValue(maxValue: Int) -> Int`)

func randomValue(maxValue: Int) -> Int {
    switch(arc4random_uniform(6)) {
    case 1:
        return Int(ceil(Float(maxValue) * 0.7))
    case 2:
        return Int(ceil(Float(maxValue) * 0.9))
    case 3, 4, 5:
        return maxValue
    default:
        return 0
    }
}

var studentPoints: [String: [String: [Int]]] = [:]

// Ваш код починається тут

studentsGroups.forEach { group, students in
    
    var studentsWithMarks: [String: [Int]] = [:]
    
    students.forEach { student in

        var marks: [Int] = []
        points.forEach { max in
            marks.append(randomValue(maxValue: max))
        }
        studentsWithMarks[student] = marks
    }
    studentPoints[group] = studentsWithMarks
}

// Ваш код закінчується тут

print("Завдання 2")
print(studentPoints)
print()

// Завдання 3
// Заповніть словник, де:
// - ключ – назва групи
// - значення – словник, де:
//   - ключ – студент, який відносяться до відповідної групи
//   - значення – сума оцінок студента

var sumPoints: [String: [String: Int]] = [:]

// Ваш код починається тут

studentPoints.forEach { group, students in
    
    var studentsWithMarksSum: [String: Int] = [:]
    
    students.forEach { student, marks in
        studentsWithMarksSum[student] = marks.reduce(0, { $0 + $1 })
    }
    sumPoints[group] = studentsWithMarksSum
}

// Ваш код закінчується тут

print("Завдання 3")
print(sumPoints)
print()

// Завдання 4
// Заповніть словник, де:
// - ключ – назва групи
// - значення – середня оцінка всіх студентів групи

var groupAvg: [String: Float] = [:]

// Ваш код починається тут

sumPoints.forEach { group, students in
        
    let sum = students.reduce(0, { $0 + $1.value })
    
    groupAvg[group] = Float(sum) / Float(students.count)
}

// Ваш код закінчується тут

print("Завдання 4")
print(groupAvg)
print()

// Завдання 5
// Заповніть словник, де:
// - ключ – назва групи
// - значення – масив студентів, які мають >= 60 балів

var passedPerGroup: [String: [String]] = [:]

// Ваш код починається тут

sumPoints.forEach { group, students in
        
    var groupstudents: [String] = []
    
    students.forEach { student, mark in
        if mark >= 60 {
            groupstudents.append(student)
        }
    }
    
    passedPerGroup[group] = groupstudents
}

// Ваш код закінчується тут

print("Завдання 5")
print(passedPerGroup)

// Приклад виведення. Ваш результат буде відрізнятися від прикладу через використання функції random для заповнення масиву оцінок та через інші вхідні дані.
//
//Завдання 1
//["ІВ-73": ["Гончар Юрій", "Давиденко Костянтин", "Капінус Артем", "Науменко Павло", "Чередніченко Владислав"], "ІВ-72": ["Бортнік Василь", "Киба Олег", "Овчарова Юстіна", "Тимко Андрій"], "ІВ-71": ["Андрющенко Данило", "Гуменюк Олександр", "Корнійчук Ольга", "Музика Олександр", "Трудов Антон", "Феофанов Іван"]]
//
//Завдання 2
//["ІВ-73": ["Давиденко Костянтин": [5, 8, 9, 12, 11, 12, 0, 0, 14], "Капінус Артем": [5, 8, 12, 12, 0, 12, 12, 12, 11], "Науменко Павло": [4, 8, 0, 12, 12, 11, 12, 12, 15], "Чередніченко Владислав": [5, 8, 12, 12, 11, 12, 12, 12, 15], "Гончар Юрій": [5, 6, 0, 12, 0, 11, 12, 11, 14]], "ІВ-71": ["Корнійчук Ольга": [0, 0, 12, 9, 11, 11, 9, 12, 15], "Музика Олександр": [5, 8, 12, 0, 11, 12, 0, 9, 15], "Гуменюк Олександр": [5, 8, 12, 9, 12, 12, 11, 12, 15], "Трудов Антон": [5, 0, 0, 11, 11, 0, 12, 12, 15], "Андрющенко Данило": [5, 6, 0, 12, 12, 12, 0, 9, 15], "Феофанов Іван": [5, 8, 12, 9, 12, 9, 11, 12, 14]], "ІВ-72": ["Киба Олег": [5, 8, 12, 12, 11, 12, 0, 0, 11], "Овчарова Юстіна": [5, 8, 12, 0, 11, 12, 12, 12, 15], "Бортнік Василь": [4, 8, 12, 12, 0, 12, 9, 12, 15], "Тимко Андрій": [0, 8, 11, 0, 12, 12, 9, 12, 15]]]
//
//Завдання 3
//["ІВ-72": ["Бортнік Василь": 84, "Тимко Андрій": 79, "Овчарова Юстіна": 87, "Киба Олег": 71], "ІВ-73": ["Капінус Артем": 84, "Науменко Павло": 86, "Чередніченко Владислав": 99, "Гончар Юрій": 71, "Давиденко Костянтин": 71], "ІВ-71": ["Корнійчук Ольга": 79, "Трудов Антон": 66, "Андрющенко Данило": 71, "Гуменюк Олександр": 96, "Феофанов Іван": 92, "Музика Олександр": 72]]
//
//Завдання 4
//["ІВ-71": 79.333336, "ІВ-72": 80.25, "ІВ-73": 82.2]
//
//Завдання 5
//["ІВ-72": ["Бортнік Василь", "Киба Олег", "Овчарова Юстіна", "Тимко Андрій"], "ІВ-73": ["Давиденко Костянтин", "Капінус Артем", "Чередніченко Владислав", "Гончар Юрій", "Науменко Павло"], "ІВ-71": ["Музика Олександр", "Трудов Антон", "Гуменюк Олександр", "Феофанов Іван", "Андрющенко Данило", "Корнійчук Ольга"]]


// MARK: -  Частина 2

final class TimeAH {
    
    // Class funcs
    
    class func emptyTimeDate() -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: "00:00:00")!
    }
    
    class func sum(_ lhs: TimeAH, _ rhs: TimeAH) -> TimeAH {
        var newDate = lhs.date()
        newDate.addTimeInterval(rhs.date().timeIntervalSince(TimeAH.emptyTimeDate()))
        return TimeAH(date: newDate)
    }
    
    class func difference(_ lhs: TimeAH, _ rhs: TimeAH) -> TimeAH {
        var newDate = lhs.date()
        newDate.addTimeInterval(-rhs.date().timeIntervalSince(TimeAH.emptyTimeDate()))
        return TimeAH(date: newDate)
    }
    
    // Properties
    
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    // Init
    
    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        
        self.hours = (0...23).contains(hours) ? hours : 0
        self.minutes = (0...59).contains(minutes) ? minutes : 0
        self.seconds = (0...59).contains(seconds) ? seconds : 0
    }
    
    init(date: Date) {
        let calendar = Calendar.current
//        calendar.locale = .current
        self.hours = calendar.component(.hour, from: date)
        self.minutes = calendar.component(.minute, from: date)
        self.seconds = calendar.component(.second, from: date)
    }
    
    // Private funcs
    
    private func date() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.date(from: "\(hours):\(minutes):\(seconds)")!
    }
    
    // Public funcs
    
    public func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:​​mm:​​ss ​a"
        
        return dateFormatter.string(from: date())
    }
    
    public func sum(with item: TimeAH) -> TimeAH {
        
//        let seconds = date().timeIntervalSinceReferenceDate + item.date().timeIntervalSinceReferenceDate
        
//        let newSeconds = Int(seconds) % 60
//        let newMinutes = Int(seconds / 60) % 60
//        let newHours = Int(seconds / 60 / 60) % 24
        
//        return TimeAH(hours: newHours, minutes: newMinutes, seconds: newSeconds)
        
        var newDate = date()
        newDate.addTimeInterval(item.date().timeIntervalSince(TimeAH.emptyTimeDate()))
        return TimeAH(date: newDate)
    }
    
    public func difference(with item: TimeAH) -> TimeAH {
        
//        let seconds = 86400 + date().timeIntervalSince(item.date())
//
//        let newSeconds = Int(seconds) % 60
//        let newMinutes = Int(seconds / 60) % 60
//        let newHours = Int(seconds / 60 / 60) % 24
//
//        return TimeAH(hours: newHours, minutes: newMinutes, seconds: newSeconds)
        
        var newDate = date()
        newDate.addTimeInterval(-item.date().timeIntervalSince(TimeAH.emptyTimeDate()))
        return TimeAH(date: newDate)
    }
}


print("\nЧАСТИНА 2")

let midnight = TimeAH()
let oneSecondAfterMidnight  = TimeAH(hours: 00, minutes: 00, seconds: 01)
let oneSecondBeforeMidnight  = TimeAH(hours: 23, minutes: 59, seconds: 59)
let now = TimeAH(date: Date())

let newTimeFromSum = oneSecondBeforeMidnight.sum(with: oneSecondAfterMidnight)
let newTimeFromDif = midnight.difference(with: oneSecondAfterMidnight)

let newTimeFromClassSum = TimeAH.sum(now, now)
let newTimeFromClassDif = TimeAH.difference(midnight, now)

print("\nЗавдання 6.a")
print("midnight:                ", midnight.time())
print("oneSecondAfterMidnight:  ", oneSecondAfterMidnight.time())
print("oneSecondBeforeMidnight: ", oneSecondBeforeMidnight.time())
print("now:                     ", now.time())

print("\nЗавдання 6.b. Сума 'oneSecondBeforeMidnight' та 'oneSecondAfterMidnight'")
print(newTimeFromSum.time())
print("\nЗавдання 6.c. Різниця 'midnight' та 'oneSecondAfterMidnight'")
print(newTimeFromDif.time())
print("\nЗавдання 7.a. Сума 'now' та 'now'")
print(newTimeFromClassSum.time())
print("\nЗавдання 7.b. Різниця 'midnight' та 'now'")
print(newTimeFromClassDif.time())
