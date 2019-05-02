//
//  DetailRecipeViewController.swift
//  MeCook Recipe
//
//  Created by Allan Shivji on 5/2/19.
//  Copyright © 2019 Allan Shivji. All rights reserved.
//

import UIKit
import MessageUI

class DetailRecipeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var myTitle = String()
    var myIngredients = String()
    var mySteps = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextArea: UITextView!
    @IBOutlet weak var stepsTextArea: UITextView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.stepsTextArea.layer.borderColor = UIColor.lightGray.cgColor
        self.stepsTextArea.layer.borderWidth = 1
        self.stepsTextArea.layer.cornerRadius = 10
        self.stepsTextArea.textContainerInset = UIEdgeInsets(top: 6, left: 10, bottom: 0, right: 0)
        
        self.shareButton.layer.cornerRadius = 18
        self.shareButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.shareButton.layer.shadowColor = UIColor.lightGray.cgColor
        self.shareButton.layer.shadowOpacity = 20
        self.shareButton.layer.shadowRadius = 5
        self.shareButton.layer.masksToBounds = false

        // Do any additional setup after loading the view.
        titleLabel.text = myTitle
        ingredientsTextArea.text = myIngredients
        stepsTextArea.text = mySteps
    }
    
    @IBAction func emailButton(_ sender: Any) {
        
        showMailComposer()
        
        
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            print("ERROR...")
            mailError()
            return
        }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        
        mailViewController.setToRecipients([""])
        mailViewController.setSubject("Hey Checkout this New Recipe")
        mailViewController.setMessageBody("<h1>\(myTitle)</h1>", isHTML: true)
        
        present(mailViewController, animated: true)
        
    }
    
    
    func mailError() {
        let emailAlert = UIAlertController(title: "Unable to send Email", message: "Error occurred while sending an email through this device. Please check the emial configuration on this device.", preferredStyle: .alert)

        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)

        emailAlert.addAction(dismiss)
        self.present(emailAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
