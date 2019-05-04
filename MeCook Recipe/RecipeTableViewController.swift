//
//  RecipeTableViewController.swift
//  MeCook Recipe
//
//  Created by Allan Shivji on 3/2/19.
//  Copyright © 2019 Allan Shivji. All rights reserved.
//

import UIKit
import CloudKit

class RecipeTableViewController: UITableViewController {
    
    var recipes = [CKRecord]()
    var refresh:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        }

        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load Recipes")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
        
        loadData()
    }

    
    @objc func loadData() {
        
        if !CheckInternet.Connection() {
            checkInternetConnection()
        }
        
        recipes = [CKRecord]()
        let publicData = CKContainer.default().publicCloudDatabase
        
        let queryData = CKQuery(recordType: "Recipe", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        
        
        publicData.perform(queryData, inZoneWith: nil) { (results, error) in
            
            if let recipes = results {
                self.recipes = recipes

                DispatchQueue.main.async {
                        [weak self] in
                    self?.tableView.reloadData()
                    self?.refresh.endRefreshing()
                }
            }
        }
    }
    
 
    @IBAction func addRecipe(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Recipe", message: "", preferredStyle: .alert)
        
        let textView = UITextView()
        textView.text = "Steps: \n"
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        
        textView.frame = controller.view.frame
        controller.view.addSubview(textView)
        
        alert.setValue(controller, forKey: "contentViewController")
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.4)
        
        alert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            textField.placeholder = "Title"
        })
        
        alert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            textField.placeholder = "Ingredients"
        })

        alert.view.addConstraint(height)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {(action:UIAlertAction) -> Void in
            let textField = alert.textFields![0]
            let textField2 = alert.textFields![1]
            
            if textField.text != "" && textField2.text != "" {
                
                //uploading data to cloud
                let newRecipe = CKRecord(recordType: "Recipe")
                newRecipe["title"] = textField.text as CKRecordValue?
                newRecipe["ingredients"] = textField2.text as CKRecordValue?
                newRecipe["steps"] = textView.text as CKRecordValue?
                
                let publicData = CKContainer.default().publicCloudDatabase
                publicData.save(newRecipe, completionHandler: { (record, error) in
                    
                    if error == nil{
                        print("Data Saved to iCloud.......")
                        DispatchQueue.main.async {
                            self.tableView.beginUpdates()
                            self.recipes.insert(newRecipe, at: 0)
                            let indexPath = NSIndexPath(row: 0, section: 0)
                            self.tableView.insertRows(at: [indexPath as IndexPath], with: .top)
                            self.tableView.endUpdates()
                        }
                    } else {
                        
                        let iCloudAlert = UIAlertController(title: "Unable to upload Data to iCloud", message: "Make sure you have signed in into your iCloud account or check your Internet connection.", preferredStyle: .alert)
                        
                        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        iCloudAlert.addAction(dismiss)
                        self.present(iCloudAlert, animated: true, completion: nil)
                        
                    }
                })
            } else {
                
                if (textField.text == "") {
                    
                    let alert = UIAlertController(title: "ERROR", message: "Please enter title of the Recipe.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                } else if (textField2.text == "") {
                    
                    let alert = UIAlertController(title: "ERROR", message: "Please enter Ingredients for the Recipe.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
        
        let myDestination = segue.destination as! DetailRecipeViewController
        
        let selectedData = recipes[indexPath.row]
        
        let myOwnTitle = selectedData["title"] as? String
        let myOwnIngredients = selectedData["ingredients"] as? String
        let myOwnSteps = selectedData["steps"] as? String
        
        myDestination.myTitle = myOwnTitle!
        myDestination.myIngredients = myOwnIngredients!
        myDestination.mySteps = myOwnSteps!
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        /* Animations for tableview start here */
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.5) {
            cell.layer.transform = CATransform3DIdentity
        }
        
        /* Animations for tableview end here */
        
        if recipes.count == 0 {
            return cell
        }
        
        let recipe = recipes[indexPath.row]
        
        
        if let recipeContent = recipe["title"] as? String {
            cell.textLabel?.text = recipeContent
        }

        return cell
    }
    
    func checkInternetConnection () {
        
        let alert = UIAlertController(title: "Cellular Data is Turned Off", message: "Turn on cellular data or use Wi-Fi to access data.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
