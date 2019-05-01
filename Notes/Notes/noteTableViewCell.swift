//
//  noteTableViewCell.swift
//  Notes
//
//  Created by Cistudent on 4/30/19.
//  Copyright © 2019 Learning Mobile Apps. All rights reserved.
//

import UIKit

class noteTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowColor = UIColor(red: 0/255.0, green:0/255.0, blue:0/255.0, alpha:1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 2
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(note: Note) {
        
        self.noteNameLabel.text = note.noteName
        self.noteDescriptionLabel.text = note.noteDescription
        
        
    }

}
