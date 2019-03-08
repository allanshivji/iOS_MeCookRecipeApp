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

        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load Recipes")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
        
        loadData()
    }

    
    @objc func loadData() {
        
        recipes = [CKRecord]()
        let publicData = CKContainer.default().publicCloudDatabase
        
        let queryData = CKQuery(recordType: "Recipe", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        publicData.perform(queryData, inZoneWith: nil) { (results, error) in
            
            if let recipes = results {
                self.recipes = recipes
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tableView.reloadData()
//
//                })
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
                //                print(String(textField.text!))
                //                print(String(textField2.text!))
                //                print(String(textView.text!))
                
                
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
                        print("Not Saved")
                        
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if recipes.count == 0 {
            return cell
        }
        
        let recipe = recipes[indexPath.row]
        
        if let recipeContent = recipe["title"] as? String {
            cell.textLabel?.text = recipeContent
        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
