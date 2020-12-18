import UIKit
import RealmSwift

class AddBirthdaysController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    
    var editItem: Birthday?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        
        picker.maximumDate = Date()
        
        if let editItem = editItem {
            
            title = "\(editItem.name)"
            
            nameTextField.text = editItem.name
            picker.date = editItem.date
            saveButton.isEnabled = true
        } else {
            nameTextField.becomeFirstResponder()
        }

    }

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if let editItem = editItem {
            try! realm.write {
                editItem.name = nameTextField.text!
                editItem.date = picker.date
                editItem.dayLeft = Helper.daysLeft(date: picker.date)
            }
        } else {
            let item = Birthday()
            item.name = nameTextField.text!
            item.date = picker.date
            item.dayLeft = Helper.daysLeft(date: picker.date)

            try! realm.write {
                realm.add(item)
            }
        }
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("added"), object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = nameTextField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        saveButton.isEnabled = !newText.isEmpty
        return true
    }

    
}
