import UIKit
import CoreData

class RecentsStore {
    static var shared = RecentsStore()
    var allCalls: [RecentCall]
    var missedCalls: [RecentCall] {
        return allCalls.filter { $0.isMissed }
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter
    }()
    
    static let callArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    init() {
        print(RecentsStore.callArchiveURL)
        allCalls = []
        loadData()
        
        allCalls.sort { $0.date!.compare($1.date!) == .orderedDescending }
    }
    
    private func loadData() {
        let fetchRequest: NSFetchRequest<RecentCall> = RecentCall.fetchRequest()

        do {
            allCalls = try AllContactsStore.viewContext.fetch(fetchRequest)
            
        } catch {
            print("Error loading recents",error)
        }
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
    }
    
    func callsCount() -> Int {
        return allCalls.count
    }
    
    func getCall(at indexPath: IndexPath) -> RecentCall {
        return allCalls[indexPath.row]
    }
    
    func getContact(idx: IndexPath) -> Contact {
        return allCalls[idx.row].contact!
    }
    
    func missedCallsCount() -> Int {
        return missedCalls.count
    }
    
    func getMissedCall(at indexPath: IndexPath) -> RecentCall {
        return missedCalls[indexPath.row]
    }
    
    func removeCall(at idx: IndexPath) {
        AllContactsStore.viewContext.delete(allCalls[idx.row])
        allCalls.remove(at: idx.row)
    }
    
    func removeMissedCall(at idx: IndexPath) {
        var count = 0
        for i in 0 ..< allCalls.count {
            if allCalls[i].isMissed {
                if count == idx.row {
                    AllContactsStore.viewContext.delete(allCalls[i])
                    allCalls.remove(at: i)
                    break
                }
                count += 1
            }
        }
    }
    
    func deleteAll() {
        allCalls = []
    }
}

