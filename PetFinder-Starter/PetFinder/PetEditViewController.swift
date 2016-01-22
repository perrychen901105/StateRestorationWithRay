//
//  PetEditViewController.swift
//  PetFinder
//
//  Created by Luke Parham on 9/3/15.
//  Copyright © 2015 Luke Parham. All rights reserved.
//

import UIKit

class PetEditViewController: UIViewController {
  
  var saveButton = UIBarButtonItem()
  var profileImageView = UIImageView()
  
  var nameTextField = UITextField()
  var ageTextField  = UITextField()
  
  var petId: Int?
  
  override func loadView() {
    view = UIView()
    
    automaticallyAdjustsScrollViewInsets = false
    edgesForExtendedLayout = .None
    
    let stackView = UIStackView(arrangedSubviews: [profileImageView, nameTextField, ageTextField])
    stackView.axis = .Vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 10.0
    
    view.addSubview(stackView)
    
    stackView.leadingAnchor.constraintEqualToAnchor(view.readableContentGuide.leadingAnchor).active = true
    stackView.trailingAnchor.constraintEqualToAnchor(view.readableContentGuide.trailingAnchor).active = true
    stackView.topAnchor.constraintEqualToAnchor(view.layoutMarginsGuide.topAnchor, constant: 20.0).active = true
    
    profileImageView.heightAnchor.constraintEqualToConstant(300.0).active = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    restorationIdentifier = "PetEditViewController"
    //UIKit needs to know where to get the view controller reference. Add the following code just below the point where you assign restorationIdentifier:
    restorationClass = PetEditViewController.self
    
    view.backgroundColor = UIColor.whiteColor()
    
    profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
    profileImageView.clipsToBounds = true
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveWasTapped")
    
    nameTextField.borderStyle = .RoundedRect
    ageTextField.borderStyle = .RoundedRect
    
    nameTextField.placeholder = "Name"
    ageTextField.placeholder = "Age"
    
    profileImageView.contentMode = .ScaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.backgroundColor = UIColor.lightGrayColor()
    
    setPet()
  }
  
  func saveWasTapped() {
    MatchedPetsManager.sharedManager.updatePet(id: petId!, name: nameTextField.text, age: ageTextField.text)
    
    navigationController?.popViewControllerAnimated(true)
  }
  
  func setPet() {
    guard let petId = petId, pet = MatchedPetsManager.sharedManager.petForId(petId) else {
      return
    }
    
    nameTextField.text = "\(pet.name)"
    ageTextField.text = "\(pet.age)"
    profileImageView.image = UIImage(data: pet.imageData)
  }
  
  override func encodeRestorableStateWithCoder(coder: NSCoder) {
    if let image = profileImageView.image {
      coder.encodeObject(UIImagePNGRepresentation(image), forKey: "image")
    }
    
    if let name = nameTextField.text {
      coder.encodeObject(name, forKey: "name")
    }
    
    if let age = ageTextField.text {
      coder.encodeObject(age, forKey: "age")
    }
    
    coder.encodeInt(Int32(petId!), forKey: "id")
    
    super.encodeRestorableStateWithCoder(coder)
  }
  
  override func decodeRestorableStateWithCoder(coder: NSCoder) {
    if let imageData = coder.decodeObjectForKey("image") as? NSData {
      profileImageView.image = UIImage(data: imageData)
    }
    
    if let name = coder.decodeObjectForKey("name") as? String {
      nameTextField.text = name
    }
    
    if let age = coder.decodeObjectForKey("age") as? String {
      ageTextField.text = age
    }
    
    petId = Int(coder.decodeIntegerForKey("id"))
    
    super.decodeRestorableStateWithCoder(coder)
  }
}
//return an instance of the class
extension PetEditViewController: UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        let vc = PetEditViewController()
        return vc
    }
}