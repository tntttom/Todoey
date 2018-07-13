//
//  ViewController.swift
//  Todoey
//
//  Created by Tommy Nguyen on 7/11/18.
//  Copyright © 2018 Tommy Nguyen. All rights reserved.
//

import UIKit

import RealmSwift

class TodoListViewController: UITableViewController{
    
    let realm = try? Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
        //Decodes item from PLIST
       
    }
    
    //MARK: - Tableview Datasource Methods
    
    //Sets number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return toDoItems?.count ?? 1
    }
    
    //Sets title of row + Checkmark
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
            
        //Ternary operator
        // Value = condition ? trueValue : falseValue
        cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
       
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    //What happens when you select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
        do{
            try realm?.write {

                item.done != item.done
            }
        } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        

    }
    
    //MARK: - Add New Items
    
    //Alert comes up when adding new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
            do{
                try self.realm?.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                    print("Unable to save items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            textField = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods

    func loadItems() {

       toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
 

}

//MARK: - SearchBarMethods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        toDoItems = toDoItems?.filter("title CONTAINS %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}












