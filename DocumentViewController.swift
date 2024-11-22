//
//  DocumentViewController.swift
//  DocumentApp
//
//  Created by Hugo RAGUIN on 11/18/24.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TextView: UITextView!
    
    // Variable pour stocker l'objet DocumentFile
    var document: DocumentTableViewController.DocumentFile?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Affiche l'image si le document est défini
        if let document = document, let imageName = document.imageName {
            ImageView.image = UIImage(named: imageName)
            title = document.title
        }
    }
}
