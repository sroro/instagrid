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
    @IBOutlet weak var upLeftButton: UIButton!
    @IBOutlet weak var upRightButton: UIButton!
    @IBOutlet weak var stackviewBottom: UIStackView!
    @IBOutlet weak var BLeftButton: UIButton!
    @IBOutlet weak var BRightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var viewMain: UIView!

    @IBAction func didTapPhotoButton(_ sender: UIButton!){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        let imagePicker = UIImagePickerController()
        /*puts the memory address of the button on which the user pressed
          in the selectedButton variable so I can use it later*/
        self.selectedButton = sender
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
            }
        }
    
    /*  - Hide a stackview button to make the desired shape
        - hide the images of the buttons not selected */
      @IBAction func didTapLayoutButton(_ sender: UIButton) {
          selectLayout(style: sender.tag)
       }
    
// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

       /*in viewDidLoad, add gesture management =>
         If I do a swipeUp or a swipeLeft on my label, execute the manageSwipe function*/
        
        // manages the style of the viewMain at launch
        selectLayout(style: currentStyle)
        
        
        //Manage gesture of swipe up or left
        let up = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        let left = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        up.direction = .up
        left.direction = .left
        swipeUp.addGestureRecognizer(up)
        swipeUp.addGestureRecognizer(left)
        
        //  notification manage screen for modification text UILabel
        NotificationCenter.default.addObserver(self, selector: #selector(manageOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
     
    }
    
// MARK: - Properties
    let screenHeight = UIScreen.main.bounds.height
 
    var currentStyle: Int = 3
    var isLandscape: Bool {
        if #available(iOS 13, *){
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape}
    }
   // create an empty variable in the class which will be ready to receive
    // the memory address of a button, but don't put anything in it yet
    
    var selectedButton: UIButton?
    
//    MARK: - Méthodes
       @objc func manageOrientation() {
            selectLayout(style: currentStyle)
            if isLandscape {
                swipeUp.text = "Swipe left to share"
            } else {
                swipeUp.text = "Swipe up to share"
            }
        }
    
    // animation of viewMain after doing a swipe
    @objc func animeViewMain() {
        if isLandscape{ UIView.animate(withDuration: 0.5, animations: {
                   self.viewMain.transform = CGAffineTransform(translationX: -self.screenHeight, y:0)
               }, completion: nil) 
               } else { UIView.animate(withDuration: 0.5, animations: {
                   self.viewMain.transform = CGAffineTransform(translationX: 0, y: -self.screenHeight)
               }, completion: nil)
               }
        }
    
    private func shareImage() {
        // tranform UIView into image
        let renderer = UIGraphicsImageRenderer(size: viewMain.bounds.size)
        let image = renderer.image { ctx in
            viewMain.drawHierarchy(in: viewMain.bounds, afterScreenUpdates: true)
        }
        let items = [image]
              let share = UIActivityViewController(activityItems: items, applicationActivities: nil)
              share.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:Bool, returnedItems: [Any]?, error: Error?) in
              if !completed {
                self.viewMain.transform = .identity
                return
              }
                self.viewMain.transform = .identity
            }
              present(share, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage
        self.selectedButton?.imageView?.contentMode = .scaleAspectFill // garde la dimension de l'image
        self.selectedButton?.setImage(selectedImage, for: UIControl.State.normal)
        picker.dismiss(animated: true, completion: nil)
        selectedButton = nil /* resets the selectednedButton to nil, because we have finished processing on it. So we shouldn't use it anymore and if we try to use it, it's not normal */
    }
    
    @objc func manageSwipe(sender: UISwipeGestureRecognizer) {
       /* To continue, I want my sender to have received a .left direction
           AND the phone is in landscape
           OR that my sender has received a .up direction
           AND that the phone is not in landscape */
        guard  sender.direction == .left && isLandscape || sender.direction == .up && !isLandscape else {
                return
             }
        animeViewMain()
        shareImage()
    }
    
    
    func selectLayout(style:Int) {
        currentStyle = style
        switch style {
        case 1:
              BRightButton.isHidden = false
              upRightButton.isHidden = true
              centerButton.imageView?.isHidden = true
              rightButton.imageView?.isHidden = true
              leftButton.imageView?.isHidden = false
        case 2:
            BRightButton.isHidden = true
            upRightButton.isHidden = false
            centerButton.imageView?.isHidden = false
            leftButton.imageView?.isHidden = true
            rightButton.imageView?.isHidden = true
        case 3:
            BRightButton.isHidden = false
            upRightButton.isHidden = false
            centerButton.imageView?.isHidden = true
            leftButton.imageView?.isHidden = true
            rightButton.imageView?.isHidden = false
        default:
            break
        }
    }
}
