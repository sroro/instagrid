//
//  ViewController.swift
//  instagrid
//
//  Created by Rodolphe Schnetzer on 10/11/2019.
//  Copyright © 2019 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
// MARK: - IBOulet / IBAction
    
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
    @IBOutlet weak var viewMain: UIView!
    
    @IBAction func didTapePhotoButton(_ sender: UIButton!){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let imagePicker = UIImagePickerController()
                   //met l'adresse mémoire du bouton sur lequel l'utilisateur a appuyé dans la variable selectionnedButton comme ca je peux l'utiliser plus tard
        self.selectionnedButton = sender
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
            }
        }
    
    /*  - Cacher un bouton du stackview pour faire la forme souhaite
          - cacher les images des boutons non selectionns */
      @IBAction func didTapLayoutButton(_ sender: UIButton) {
          selectLayout(style: sender.tag)
       }
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

       /*dans le viewDidLoad, ajoute la gestion des geste => Si je fait un swipeUp ou un swipeLeft sur mon label, execute la fonction manageSwipe */
        selectLayout(style: currentStyle)
        
        let up = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        let left = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        up.direction = .up
        left.direction = .left
        swipeUp.addGestureRecognizer(up)
        swipeUp.addGestureRecognizer(left)
        
        //      notification gere orientation ecran pour modif text UILabel
        NotificationCenter.default.addObserver(self, selector: #selector(manageOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
     
    }
    
// MARK: - Properties
    
    var currentStyle: Int = 3
    var isLandscape: Bool {
        if #available(iOS 13, *){
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape}
    }
    // créé une variable vide dans la classe qui sera prête à accueillir
    // l'adresse mémoire d'un bouton, mais ne met rien dedans pour l'instant
    
    var selectionnedButton: UIButton?
    
//    MARK: - Méthodes
       
    @objc func manageOrientation() {
//     if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
        selectLayout(style: currentStyle)
        if isLandscape {
            swipeUp.text = "Swipe left to share"
        } else {
            swipeUp.text = "Swipe up to share"
        }
    }

    @objc func manageSwipe(sender: UISwipeGestureRecognizer) {
      
       /* Pour continuer, je veux que mon sender ait recu une direction .left ET que le téléphone soit en landscape OU que mon sender ait recu une direction .up ET que le téléphone ne soit pas en landscape*/
     
        guard  sender.direction == .left && isLandscape || sender.direction == .up && !isLandscape else {
                return
             }
        
        // transformer UIView en UIImage
       let renderer = UIGraphicsImageRenderer(size: viewMain.bounds.size)
       let image = renderer.image { ctx in
           viewMain.drawHierarchy(in: viewMain.bounds, afterScreenUpdates: true)
       }
        
        // share l'image transformer
        let items = [image]
        let share = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(share, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage
        self.selectionnedButton?.setImage(selectedImage, for: UIControl.State.normal)
        picker.dismiss(animated: true, completion: nil)
        selectionnedButton = nil /* remet le selectionnedButton a nil, parce qu'on a fini le traitement dessus. Donc on ne
        devrait plus s'en servir et si on essaye de s'en servir, c'est pas normal */
    }
    
    func selectLayout(style:Int) {
        currentStyle = style
        switch style {
        case 1:
              BRightButton.isHidden = false
              UpRightButton.isHidden = true
              CenterButton.imageView?.isHidden = true
              RightButton.imageView?.isHidden = true
              LeftButton.imageView?.isHidden = false
        case 2:
            BRightButton.isHidden = true
            UpRightButton.isHidden = false
            CenterButton.imageView?.isHidden = false
            LeftButton.imageView?.isHidden = true
            RightButton.imageView?.isHidden = true
            
        case 3:
            BRightButton.isHidden = false
            UpRightButton.isHidden = false
            CenterButton.imageView?.isHidden = true
            LeftButton.imageView?.isHidden = true
            RightButton.imageView?.isHidden = false
        default:
            break
        }
    }
}
