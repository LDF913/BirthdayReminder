import UIKit
import RealmSwift
import UserNotifications

class AddBirthdaysController: UITableViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var userImage: UIImageView!
    
    var editItem: Birthday?
    var imageChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        
        picker.maximumDate = Date()
        
        if let editItem = editItem {
            
            title = "\(editItem.name)"
            
            nameTextField.text = editItem.name
            picker.date = editItem.date
            if let data = editItem.userImageData {
                userImage.image = UIImage(data: data)
                userImage.clipsToBounds = true
                userImage.layer.cornerRadius = userImage.frame.height / 2
            }
            
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [editItem.id])

            saveButton.isEnabled = true
        } else {
            nameTextField.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo-1")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let image = imageChanged ? userImage.image : #imageLiteral(resourceName: "cake")
        let imageData = image?.pngData()
        
        if let editItem = editItem {
            try! realm.write {
                editItem.name = nameTextField.text!
                editItem.date = picker.date
                editItem.dayLeft = Helper.daysLeft(date: picker.date)
                editItem.userImageData = imageData
                editItem.id = UUID().uuidString
            }
            
            appDelegate.scheduleNotificationForToday(name: editItem.name, id: editItem.id, date: editItem.date)
            
        } else {
            let item = Birthday()
            item.name = nameTextField.text!
            item.date = picker.date
            item.dayLeft = Helper.daysLeft(date: picker.date)
            item.userImageData = imageData
            item.id = UUID().uuidString
            
            appDelegate.scheduleNotificationForToday(name: item.name, id: item.id, date: item.date)

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

extension AddBirthdaysController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        userImage.image = info[.editedImage] as? UIImage
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height / 2
        
        imageChanged = true
        
        dismiss(animated: true)
    }
}

