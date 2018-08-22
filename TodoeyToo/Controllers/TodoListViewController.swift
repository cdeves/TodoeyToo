//
//  ViewController.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var categoryArray = [String]()
    var categoryTitle: String?
    
    //create a path at which data will be saved
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print(dataFilePath)
        
        loadItems()

    }
    
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item
        
        return cell
        
    }

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //update the change to "done" property in the saved data array at the documents path
        saveItems()
        
        //selected row flashes grey instead of remaining grey
        tableView.deselectRow(at: indexPath, animated: true)
        
        //record the currently selected category title
        categoryTitle = categoryArray[indexPath.row]
        
        //segue to appropriate ToDoItems view controller
        performSegue(withIdentifier: "toItemView", sender: self)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemView" {
            let newViewController = segue.destination as! ToDoItemsTableViewController
            newViewController.currentCategoryTitle = categoryTitle!
        }
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create an alert to allow user to add new data to the todo list
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category Title", style: .default) { (action) in
            
            //what will happen once user clicks add item button on our UIAlert
            
            self.categoryArray.append(textField.text!)
            
            self.saveItems()
    
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new ToDo Category"
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
            let data = try encoder.encode(categoryArray)
            
            //write the array to the filepath
            try data.write(to: dataFilePath!)
            
        } catch {
            print("error encoding the data \(error)")
        }
        
        //update tableView with "done" property
        tableView.reloadData()
    }

    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                categoryArray = try decoder.decode([String].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    

}

