//
//  ToDoItemsTableViewController.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit

class ToDoItemsTableViewController: UITableViewController {

    var itemArray = [Item]()
    var currentCategoryTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = currentCategoryTitle
        //create a path at which data will be saved
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(currentCategoryTitle)Items.plist")
        
        print(dataFilePath)
        
        loadItems()
        
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
        
        //update the change to "done" property in the saved data array at the documents path
        saveItems()
        
        //selected row flashes grey instead of remaining grey
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items

    @IBAction func newItemButtonPressed(_ sender: UIBarButtonItem) {
   
        //create an alert to allow user to add new data to the todo list
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once user clicks add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new ToDo Item"
            //save what's entered in the text field to a variable accessible to everything in the addButtonPressed method
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            //encode the item array
            let data = try encoder.encode(itemArray)
            
            //write the array to the filepath
            try data.write(to: (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(currentCategoryTitle)Items.plist"))!)
            
        } catch {
            print("error encoding the data \(error)")
        }
        
        //update tableView with "done" property
        tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data = try? Data(contentsOf: (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(currentCategoryTitle)Items.plist"))!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

