import UIKit
import RealmSwift
import Contacts
import ContactsUI

class BirthdaysController: UITableViewController, CNContactPickerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var birthdaysList: Results<Birthday>!
    var filteredBirthdaysList: Results<Birthday>!
    
    var friendsList = [Friend]()
    
    var grouped: [String: [Birthday]] = [:]
    var sections: [Section] = []

    let searchController = UISearchController(searchResultsController: nil)
    var filtredUsersBirthday: Results<Birthday>!
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdaysList = realm.objects(Birthday.self).sorted(byKeyPath: "dayLeft")
        
        groupData()
        
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        NotificationCenter.default.addObserver(self, selector: #selector(added), name: Notification.Name("added"), object: nil)
    }
    
    func groupData() {
        grouped = Dictionary(grouping: birthdaysList) { item -> String in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: item.date)
            let date = calendar.date(from: components) ?? Date(timeIntervalSince1970: 0)
            return  "\(components.month!)_" + date.monthAsString()
        }

        let keys = grouped.keys.sorted{$0.localizedStandardCompare($1) == .orderedAscending}
        sections = keys.map({Section(month: $0.components(separatedBy:"_").last!, birthdays: grouped[$0]!)})
    }
    
    @objc func added() {
        groupData()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }

        return sections.count
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredBirthdaysList.count
        }

        return sections[section].birthdays.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].month
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Birthday", for: indexPath) as! BirthdayCell
        
        var birthday = Birthday()

        if isFiltering {
            birthday = filteredBirthdaysList[indexPath.row]
        } else {
            birthday = sections[indexPath.section].birthdays[indexPath.row]
        }

        cell.nameLabel.text = birthday.name
        cell.dateLabel.text = Helper.strintFromDate(date: birthday.date)
        cell.yearsLabel.text = Helper.checkDate(date: birthday.date)
        cell.daysLeftLabel.text = String(birthday.dayLeft)
        
        if let selectedPhoto = birthday.userImageData {
            cell.userPhoto.image = UIImage(data: selectedPhoto)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            let birthday = sections[indexPath.section].birthdays[indexPath.row]
                
            try! realm.write {
            realm.delete(birthday)
            }
        
        groupData()
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        performSegue(withIdentifier: "EditBirthday", sender: cell)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditBirthday" {
    let controller = segue.destination as! UINavigationController
    let targetController = controller.topViewController as! AddBirthdaysController
    if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        
        let birthday: Birthday

        if isFiltering {
            birthday = filteredBirthdaysList[indexPath.row]
        } else {
            birthday = sections[indexPath.section].birthdays[indexPath.row]
        }

    targetController.editItem = birthday
        }
    }
 }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "AddBirthday" {
            if birthdaysList.count > 3 && !UserDefaults.standard.bool(forKey: "Premium") {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Premium")
                self.present(controller, animated: true, completion: nil)
                return false
            }
        }

        return true
    }

    @IBAction func importContacts(_ sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.predicateForEnablingContact = CNContact.predicateForHavingABirthday
        contactPicker.predicateForSelectionOfContact = CNContact.predicateForHavingABirthday
        contactPicker.modalPresentationStyle = .fullScreen
        contactPicker.delegate = self
        present(contactPicker, animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
      let newFriends = contacts.compactMap {
      Friend(contact: $0)
      }
        
      for friend in newFriends {
          friendsList.append(friend)
        
        let birthdayDate = Calendar.current.date(from: friend.birthday)
        let imageData = friend.profilePicture?.pngData()
        
        let item = Birthday()
        item.name = friend.firstName
        item.date = birthdayDate!
        item.dayLeft = Helper.daysLeft(date: birthdayDate!)
        item.userImageData = imageData
        item.id = UUID().uuidString
        
        appDelegate.scheduleNotificationForToday(name: item.name, id: item.id, date: item.date)

        try! realm.write {
            realm.add(item)
        }
        
        groupData()
        
        tableView.reloadData()
    }

  }
}

extension BirthdaysController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredBirthdaysList = birthdaysList.filter("name CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}

extension CNContact {
    public static let predicateForHavingABirthday: NSPredicate = NSPredicate(format: "birthday != nil")
}
