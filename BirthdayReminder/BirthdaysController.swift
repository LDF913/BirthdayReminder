import UIKit
import RealmSwift

class BirthdaysController: UITableViewController {
    
    var birthdaysList: Results<Birthday>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birthdaysList = realm.objects(Birthday.self).sorted(byKeyPath: "dayLeft")

        NotificationCenter.default.addObserver(self, selector: #selector(added), name: Notification.Name("added"), object: nil)
    }
    
    @objc func added() {
        print(birthdaysList[0].date)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdaysList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Birthday", for: indexPath) as! BirthdayCell
        
        let birthday = birthdaysList[indexPath.row]
        
        cell.nameLabel.text = birthday.name
        cell.dateLabel.text = Helper.strintFromDate(date: birthday.date)
        cell.yearsLabel.text = Helper.checkDate(date: birthday.date)
        cell.daysLeftLabel.text = String(birthday.dayLeft)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            let birthday = birthdaysList[indexPath.row]
                
            try! realm.write {
            realm.delete(birthday)
            }

            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
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
    targetController.editItem = birthdaysList[indexPath.row]
        }
    }
 }


}
