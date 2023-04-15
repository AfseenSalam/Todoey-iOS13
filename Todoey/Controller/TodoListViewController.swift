//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Mike","Buy eggos","Find Dragon","a","b","c","d","e","f","g","h","i","j","K"]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = defaults.array(forKey: "ToDoListArray")as?[String]{
            itemArray = item
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK - Table View DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
    }
    //MARK - TableView Delegate Method
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    //
    //        cell.textLabel?.text = itemArray[indexPath.row]
    //
    //        /// Compare if current section is Available in reference Dict
    //        if let val = selectedIndex![indexPath.section]{
    //            /// If Yes
    //            /// Check IndexPath Row Value
    //            if indexPath.row == val{
    //                /// If row is found that is selected
    //                /// Make it highlight
    //                /// You can set A radio button
    //                cell.textLabel?.textColor = UIColor.red
    //            }
    //            else{
    //                /// Set default value for that section
    //                cell.textLabel?.textColor = UIColor.black
    //            }
    //        }
    //        /// If no
    //        else{
    //            /// Required to set Default value for all other section
    //            /// And
    //            /// Required to Update previous value if indexPath was selected
    //            /// In previouus index Section
    //            cell.textLabel?.textColor = UIColor.black
    //        }
    //
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK  - Add new item to the list
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To-Deoy", message: "", preferredStyle: .alert)
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create an item"
            textField = alertTextField

        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
            
        
        alert.addAction(action)
       
        present(alert, animated : true,completion : nil)
    }
    
}

