//
//  settingsViewController.swift
//  Notes
//
//  Created by Cistudent on 5/1/19.
//  Copyright © 2019 Learning Mobile Apps. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    @IBOutlet weak var pckPriority: UIPickerView!
    let priority = [
        
        "low",
        "Medium",
        "High"
        
    ]
    
    var selectedPriority: String?
    
    /*   func createPriorityPicker() {
     
     let priorityPicker = UIPickerView()
     priorityPicker.delegate = self
     
     } */
    
    
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
        
        let sortPriority = priority[row]
        
        let settings = UserDefaults.standard
        
        settings.set(sortPriority, forKey: Constants.kPriority)
        
        settings.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        
        let sortPriority = settings.string(forKey: Constants.kPriority)
        var i = 0
        for field in priority {
            if field == sortPriority {
                pckPriority.selectRow(i, inComponent: 0, animated: false)
            }
            
            i += 1
        }
        pckPriority.reloadComponent(0)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
