//
//  ViewController.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/22/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        //as soon as a value is set for selectedCategory, execute loadItems()
        didSet {
            loadItems()
        }
    }
    
    
    //create the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // set VC as searchbar delegate
//        // ctrl-drag IBOutlet for searchbar & set delegate property as below, or drag from bar to VC in storyboard
//        searchbar.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //find where our data is being stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

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

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //if a row is clicked, reverse the "done" property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        //could also update other properties here, e.g.:
//        itemArray[indexPath.row].setValue(("Completed"), forKey: "title")

//        //ORDER IS IMPORTANT for operations that delete data from persistent store.  Delete from store first!
//        //delete item from context
//        context.delete(itemArray[indexPath.row])
//
//        //THEN remove the item from the itemArray
//        itemArray.remove(at: indexPath.row)
        
        //update changes in context to the persistent store
        saveItems()
        
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
            //create a new object of type item in the context
            let newItem = Item(context: self.context)
            //must specify the attributes(properties) for every field in the object
            newItem.title = textField.text!
            newItem.done = false
            //also have to specify this item's relationship, if any
            newItem.parentCategory = self.selectedCategory
            
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
        
        do {
            //save changes from the context to the persistent store
            try context.save()
            
        } catch {
            print("error saving context: \(error)")
        }
        
        //update tableView with "done" property
        tableView.reloadData()
    }

    
    //modified this function so it can be called by the extension.  It now returns an array of Item objects.
    //this parameter declaration now also provides a default value so we can call it without any parameter: = Item.fetchRequest()
    //we also set a default value for passed in predicate parameter as nil
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //adapt loadItems() to return Items associated with the appropriate parent Category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        //make sure we never unwrap a nil value when we try to create a compound predicate (needed because the predicate we pass in may be nil)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            //store fetched data in itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
   
}



//MARK: - Search Bar Methods (Extension)
//extensions go OUTSIDE the class definition, and add functionality to the class
//extensions take the place of conforming a class to a protocol in the class definition
//conforming to protocols can make the class really long, so this is a different organizational approach

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
         //search for text entereed into searchBar, stripped of capitalization and diacritics ([cd])
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //this line replaces two lines of code:
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
    
        //sort the results of the search according to title, in ascending alphabetical order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //this line replaces two lines of code:
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when character count in search bar goes to zero, reload the table
        if searchBar.text?.count == 0 {
            loadItems()
            
            //execute this next step on the main thread
            DispatchQueue.main.async {
                
                //search bar should no longer be the thing that is currently selected
                searchBar.resignFirstResponder()
                
            }
        }
    }
    
    
}





