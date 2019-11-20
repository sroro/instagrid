//
//  ViewController.swift
//  instagrid
//
//  Created by Rodolphe Schnetzer on 10/11/2019.
//  Copyright © 2019 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var swipeUp: UILabel!
    @IBOutlet weak var stackviewUp: UIStackView!
    @IBOutlet weak var UpLeftButton: UIButton!
    @IBOutlet weak var UpRightButton: UIButton!
    @IBOutlet weak var stackviewBottom: UIStackView!
    @IBOutlet weak var BLeftButton: UIButton!
    @IBOutlet weak var BRightButton: UIButton!
    @IBOutlet weak var LeftButton: UIButton!
    @IBOutlet weak var CenterButton: UIButton!
    @IBOutlet weak var RightButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // ajout de la police à UILabel
//        swipeUp.font = UIFont(name: "Delm-Medium", size: 30)
        
    }

    @IBAction func didTapePhotoButton(_ sender: UIButton!){
    
        
    }
    
    
    
    
    
    /*  - Cacher un bouton du stackview pour faire la forme souhaite
        - cacher les images des boutons non selectionns */
    @IBAction func didTapeLeftButton(_ sender: Any) {
        BRightButton.isHidden = false
        UpRightButton.isHidden = true
        CenterButton.imageView?.isHidden = true
        RightButton.imageView?.isHidden = true
    }
    
    
    @IBAction func didTapeCenterButton(_ sender: Any) {
        UpRightButton.isHidden = false
        BRightButton.isHidden = true
        LeftButton.imageView?.isHidden = true
        RightButton.imageView?.isHidden = true   
    }
    
    
    @IBAction func didTapeRightButton(_ sender: Any) {
         BRightButton.isHidden = false
         UpRightButton.isHidden = false
         CenterButton.imageView?.isHidden = true
         LeftButton.imageView?.isHidden = true
    }
}

