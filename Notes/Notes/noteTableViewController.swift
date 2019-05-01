//
//  NoteTableViewController.swift
//  Notes
//
//  Created by Cistudent on 4/30/19.
//  Copyright © 2019 Learning Mobile Apps. All rights reserved.
//

import UIKit
import CoreData


class NoteTableViewController: UITableViewController {
    
    var notes = [Note]()
    
    var managedObjectContext: NSManagedObjectContext? {
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        retrieveNotes()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return notes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell

        // Configure the cell...
        let note: Note = notes[indexPath.row]
        cell.configureCell(note: note)
        cell.backgroundColor = UIColor.clear
        
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
         tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "                    ") { (action, indexPath) in
            
            let note = self.notes[indexPath.row]
            context.delete(note)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                self.notes = try context.fetch(Note.fetchRequest())
            }
                
            catch {
                print("Failed to delete note.")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
        delete.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "trashIcon"))
        
        return [delete]
        
    }
    
    func retrieveNotes() {
        
        managedObjectContext?.perform {
            
            self.fetchNotesFromCoreData { (notes) in
                
                if  let notes = notes {
                    
                    self.notes = notes
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func fetchNotesFromCoreData(completion: @escaping ([Note]?) -> Void) {
        
        managedObjectContext?.perform {
            
            var notes = [Note]()
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            
            do {
                
                notes = try self.managedObjectContext!.fetch(request)
                completion(notes)
            }
            
            catch {
                
                print("Could not fetch notes from CoreData:\(error.localizedDescription)")
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let noteDetailsViewController = segue.destination as! noteViewController
                let selectedNote: Note = notes[indexPath.row]
                
                noteDetailsViewController.indexPath = indexPath.row
                noteDetailsViewController.isExsisting = false
                noteDetailsViewController.note = selectedNote
                
            }
            
        }
            
        else if segue.identifier == "addItem" {
            print("User added a new note.")
            
        }
        
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
