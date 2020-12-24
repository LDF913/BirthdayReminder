import UIKit
import Contacts

class Friend {
  let firstName: String
  let birthday: DateComponents
  let profilePicture: UIImage?
  
  init(firstName: String, lastName: String, workEmail: String, birthday: DateComponents, profilePicture: UIImage?){
    self.firstName = firstName
    self.profilePicture = profilePicture
    self.birthday = birthday
  }
  
}

extension Friend {
  var contactValue: CNContact {
    let contact = CNMutableContact()
    contact.givenName = firstName
    contact.birthday = birthday
    if let profilePicture = profilePicture {
      let imageData = profilePicture.jpegData(compressionQuality: 1)
      contact.imageData = imageData
    }
    return contact.copy() as! CNContact
  }
  
  convenience init?(contact: CNContact) {
    guard let email = contact.emailAddresses.first else { return nil }
    let firstName = contact.givenName
    let lastName = contact.familyName
    let birthday = contact.birthday
    let workEmail = email.value as String
    var profilePicture: UIImage?
    if let imageData = contact.imageData {
      profilePicture = UIImage(data: imageData)
    }
    self.init(firstName: firstName, lastName: lastName, workEmail: workEmail, birthday: birthday!, profilePicture: profilePicture)
  }
}
