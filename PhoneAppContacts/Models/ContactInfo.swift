import UIKit
import CoreData

struct TypeValue<T>: Codable where T: Codable {
    var type: String!
    var value: T!
}

struct Address: Codable {
    var street: String!
    var city: String!
    var state: String!
    var ZIP: String!
    var country: String!
}

class ContactInfo: Codable {
    var number: [TypeValue<String>]!
    var email: [TypeValue<String>]!
    var ringtone: String!
    var textTone: String!
    var url: [TypeValue<String>]!
    var address: [TypeValue<Address>]!
    var birthday: [TypeValue<String>]!
    var date: [TypeValue<String>]!
    var relatedName: [TypeValue<String>]!
    var socialProfile: [TypeValue<String>]!
    var instantMessage: [TypeValue<String>]!
//    
//    var keyPaths = [
//        \ContactInfo.number,
//        \ContactInfo.email,
//        \ContactInfo.ringtone,
//        \ContactInfo.textTone,
//        \ContactInfo.url,
//        \ContactInfo.address,
//        \ContactInfo.birthday,
//        \ContactInfo.date,
//        \ContactInfo.relatedName,
//        \ContactInfo.socialProfile,
//        \ContactInfo.instantMessage
//    ]
//    
    func getContactArr() -> [[(type: String,value: String)]] {
        var arr = Array(repeating: [(String, String)](), count: 9)
        number.forEach { arr[0].append(($0.type, $0.value)) }
        email.forEach { arr[1].append(($0.type, $0.value)) }
        url.forEach { arr[2].append(($0.type, $0.value)) }
        address.forEach { arr[3].append(($0.type, "\($0.value.street ?? "")\n\($0.value.state ?? "")\n\($0.value.ZIP ?? "")\n\($0.value.city ?? "")\n\($0.value.country ?? "")")) }
        birthday.forEach { arr[4].append(($0.type, $0.value)) }
        date.forEach { arr[5].append(($0.type, $0.value)) }
        relatedName.forEach { arr[6].append(($0.type, $0.value)) }
        socialProfile.forEach { arr[7].append(($0.type, $0.value)) }
        instantMessage.forEach { arr[8].append(($0.type, $0.value)) }
        return arr
    }
    
    func changeInfo(at idx: IndexPath, with pair: TypeValue<String>) {
        switch TypeSection.allCases[idx.section] {
        case .number:
            number[idx.row] = pair
        case .email:
            email[idx.row] = pair
        case .url:
            url[idx.row] = pair
        case .birthday:
            birthday[idx.row] = pair
        case .date:
            date[idx.row] = pair
        case .relatedName:
            relatedName[idx.row] = pair
        case .socialProfile:
            socialProfile[idx.row] = pair
        case .instantMessage:
            instantMessage[idx.row] = pair
        default: break
        }
    }
    
    func changeType(at idx: IndexPath, with type: String) {
        switch TypeSection.allCases[idx.section] {
        case .number:
            number[idx.row].type = type
        case .email:
            email[idx.row].type = type
        case .url:
            url[idx.row].type = type
        case .address:
            address[idx.row].type = type
        case .birthday:
            birthday[idx.row].type = type
        case .date:
            date[idx.row].type = type
        case .relatedName:
            relatedName[idx.row].type = type
        case .socialProfile:
            socialProfile[idx.row].type = type
        case .instantMessage:
            instantMessage[idx.row].type = type
        default: break
        }
    }
    
    func insertItem(item: TypeValue<String>, at idx: IndexPath) {
        switch TypeSection.allCases[idx.section] {
        case .number:
            number.append(item)
        case .email:
            email.append(item)
        case .url:
            url.append(item)
        case .address:
            address.append(TypeValue(type: item.type, value:
                                        Address(street: "", city: "", state: "", ZIP: "", country: "")))
        case .birthday:
            birthday.append(item)
        case .date:
            date.append(item)
        case .relatedName:
            relatedName.append(item)
        case .socialProfile:
            socialProfile.append(item)
        case .instantMessage:
            instantMessage.append(item)
        default: break
        }
    }
    
    func removeItem(at idx: IndexPath) {
        switch TypeSection.allCases[idx.section] {
        case .number:
            number.remove(at: idx.row)
        case .email:
            email.remove(at: idx.row)
        case .url:
            url.remove(at: idx.row)
        case .birthday:
            birthday.remove(at: idx.row)
        case .date:
            date.remove(at: idx.row)
        case .relatedName:
            relatedName.remove(at: idx.row)
        case .socialProfile:
            socialProfile.remove(at: idx.row)
        case .instantMessage:
            instantMessage.remove(at: idx.row)
        default: break
        }
    }
    
    func changeAddress(at idx: IndexPath, with pair: TypeValue<Address>) {
        address[idx.row] = pair
    }
}
