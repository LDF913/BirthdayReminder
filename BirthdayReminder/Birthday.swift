import RealmSwift

let realm = try! Realm()

class Birthday: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var dayLeft: Int = 0
    @objc dynamic var userImageData: Data?
    @objc dynamic var id = ""
    @objc dynamic var notes = ""
}

struct Section {
    let month: String
    let birthdays: [Birthday]
}
