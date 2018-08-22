//
//  ViewController.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
 
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Slay Demogorgon"
        itemArray.append(newItem3)
        
        if let items = UserDefaults.standard.array(forKey: "ToDoItemArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator: value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType when item.done is true, is .checkmark; cell.accessoryType when item.done is false, is .none
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }

    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if a row is clicked, reverse the "done" property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //update tableView with "done" property
        tableView.reloadData()
        
        //selected row flashes grey instead of remaining grey
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert to allow user to add new data to the todo list
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once user clicks add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoItemArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new ToDo Item"
            //save what's entered in the text field to a variable accessible to everything in the addButtonPressed method
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

