//
//  notesViewController.swift
//  Notes
//
//  Created by Emmanuel Muse on 5/1/19.
//  Copyright © 2019 Learning Mobile Apps. All rights reserved.
//


import UIKit
import CoreData


import UIKit
import CoreData


class noteViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var noteInfoView: UIView!
   
    
    @IBOutlet weak var noteNameLabel: UITextField!
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Commit
    }
    
    let priority = [
    
        "low",
        "Medium",
        "High"
        
    ]
    
    var selectedPriority: String?
    
    func createPriorityPicker() {
        
        let priorityPicker = UIPickerView()
        priorityPicker.delegate = self
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priority.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priority[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = priority[row]
    }
    
    var notesFetchedResultsController: NSFetchedResultsController<Note>!
    var notes = [Note]()
    var note: Note?
    var isExsisting = false
    var indexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPriorityPicker()
        
        // Load data
        if let note = note {
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            
            //committ
        }
        
        if noteNameLabel.text != "" {
            isExsisting = true
        }
        
        // Delegates
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
        
        // Styles
        noteInfoView.layer.shadowColor =  UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        noteInfoView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        noteInfoView.layer.shadowRadius = 1.5
        noteInfoView.layer.shadowOpacity = 0.2
        noteInfoView.layer.cornerRadius = 2
        
        noteNameLabel.setBottomBorder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                try self.managedObjectContext?.save()
                completion()
                print("The note has been saved to the CoreData, be happy!")
                
            }
                
            catch let error {
                print("The note did not save into the CoreData, go cry :( : \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
    
    // Save
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "NOTE NAME" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note Description..." {
            
            let alertController = UIAlertController(title: "Missing Information", message:"You left one or more fields empty. Please make sure that all fields are filled before attempting to save.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            if (isExsisting == false) {
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
                
                if let moc = managedObjectContext {
                    let note = Note(context: moc)
                    
                    
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                    
                    saveToCoreData() {
                        
                        let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                        
                        if isPresentingInAddFluidPatientMode {
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                            
                        else {
                            self.navigationController!.popViewController(animated: true)
                            
                        }
                        
                    }
                    
                }
                
            }
                
            else if (isExsisting == true) {
                
                let note = self.note
                
                let managedObject = note
                managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                
                do {
                    try context.save()
                    
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                        
                    else {
                        self.navigationController!.popViewController(animated: true)
                        
                    }
                    
                }
                    
                catch {
                    print("Failed to update existing note.")
                }
            }
            
        }
        
    }
    
    // Cancel
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddFluidPatientMode = presentingViewController is UINavigationController
        
        if isPresentingInAddFluidPatientMode {
            dismiss(animated: true, completion: nil)
            
        }
            
        else {
            navigationController!.popViewController(animated: true)
            
        }
        
    }
    
    // Text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Note Description...") {
            textView.text = ""
            
        }
        
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 245.0/255.0, green: 79.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

