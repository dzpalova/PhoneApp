import UIKit
import CoreData

class RecentsStore {
    static var shared = RecentsStore()
    var allCalls: [[RecentCall]]
    var missedCalls: [[RecentCall]] {
        var arr = [[RecentCall]]()
        for el in allCalls {
            let innerArr = el.filter { $0.isMissed }
            if !innerArr.isEmpty {
                arr.append(innerArr)
            }
        }
        return arr
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter
    }()

    init() {
        allCalls = []
        var calls = loadData()
        parseRecentCalls(&calls)
    }
    
    private func parseRecentCalls(_ calls: inout [RecentCall]) {
        if calls.isEmpty {
            return
        }
        calls.sort { $0.date!.compare($1.date!) == .orderedDescending }
        allCalls.append([calls[0]])
        for call in calls[1...] {
            let currentCallDate = RecentCallCell.mediumDateFormatter.string(from: call.date!)
            let lastCallDate = RecentCallCell.mediumDateFormatter.string(from: allCalls.last!.first!.date!)
            
            if call.number == allCalls.last?.first?.number
                && call.isMissed == allCalls.last?.first?.isMissed
                && currentCallDate == lastCallDate {
                
                allCalls[allCalls.count - 1].append(call)
            } else {
                allCalls.append([call])
            }
        }
    }
    
    private func loadData() -> [RecentCall] {
        let fetchRequest: NSFetchRequest<RecentCall> = RecentCall.fetchRequest()
        var calls = [RecentCall]()
        do {
            calls = try AllContactsStore.viewContext.fetch(fetchRequest)
            
        } catch {
            print("Error loading recents",error)
        }
        return calls
    }
    
    @discardableResult func createRecentCall(contact: Contact?, number: String, type: String, date: Date, isMissed: Bool, isOutcome: Bool, timeInSeconds: Int) -> RecentCall {
        let newCall = RecentCall(context: AllContactsStore.viewContext)
        newCall.contact = contact
        newCall.date = date
        newCall.type = type
        newCall.isMissed = isMissed
        newCall.isOutcome = isOutcome
        newCall.number = number
        newCall.timeInSeconds = Int64(timeInSeconds)
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
        
        return newCall
    }
    
    func callsCount() -> Int {
        return allCalls.count
    }
    
    func getCalls(at indexPath: IndexPath) -> [RecentCall] {
        return allCalls[indexPath.row]
    }
    
    func getContact(idx: IndexPath) -> Contact {
        return allCalls[idx.row].first!.contact!
    }
    
    func missedCallsCount() -> Int {
        return missedCalls.count
    }
    
    func getMissedCalls(at indexPath: IndexPath) -> [RecentCall] {
        return missedCalls[indexPath.row]
    }
    
    func removeCall(at idx: IndexPath) {
        allCalls[idx.row].forEach { AllContactsStore.viewContext.delete($0) }
        allCalls.remove(at: idx.row)
        RecentCall.saveData()
    }
    
    func removeMissedCall(at idx: IndexPath) {
        var count = 0
        for i in 0 ..< allCalls.count {
            if allCalls[i].first!.isMissed {
                if count == idx.row {
                    allCalls[i].forEach { AllContactsStore.viewContext.delete($0) }
                    allCalls.remove(at: i)
                    RecentCall.saveData()
                    break
                }
                count += 1
            }
        }
    }
    
    func deleteAll() {
        for calls in allCalls {
            calls.forEach { AllContactsStore.viewContext.delete($0) }
        }
        RecentCall.saveData()
        allCalls = []
    }
}

