import RealmSwift

let realm = try! Realm()

class Birthday: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var dayLeft: Int = 0
}
