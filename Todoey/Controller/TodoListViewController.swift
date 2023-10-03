//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
        
        loadData()
        
        //        if let items = defaults.array(forKey: "ToDoListArray")as?[Item]{
        //            itemArray = items
        //        }
        // Do any additional setup after loading the view.
    }
    
    //MARK - Table View DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        //Ternary Operators
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ?.checkmark :.none
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else
        //        {
        //            cell.accessoryType = .none
        //        }
        
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
        
        let item = itemArray[indexPath.row]
        context.delete(item)
        itemArray.remove(at: indexPath.row)
       // item.done = !item.done
        //        if itemArray[indexPath.row].done == true{
        //            itemArray[indexPath.row].done =  false
        //        }else{
        //            itemArray[indexPath.row].done =  true
        //        }
        savedItems()
        tableView.reloadData()
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
           
            let newItem = Item(context:self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.savedItems()
            self.tableView.reloadData()
        }
        
        
        alert.addAction(action)
        
        present(alert, animated : true,completion : nil)
    }
    
    
    //MARK - Model Manipulation Method
    func savedItems()  {
        
        do{
            try context.save()
        }catch{
            print("Error in Saving the cntent\(error.localizedDescription)")
        }
    }
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error while loading\(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
       loadData(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
   
}
