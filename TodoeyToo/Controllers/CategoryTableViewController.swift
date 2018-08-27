//
//  CategoryTableViewController.swift
//  TodoeyToo
//
//  Created by Caitlin Sedwick on 8/23/18.
//  Copyright © 2018 Caitlin Sedwick. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    //we can try! without codesmell because realm creation can't fail except for the first time it's ever done?
    let realm = try! Realm()
    
    
    //Results data type is auto-updating and doesn't need to be monitored for changes
    var categories: Results<Category>?  //declare this as an optional
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
    }
    
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if the optional categories is nil, return a value of 1 instead
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tap into the cell created by the super
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categories?[indexPath.row] {
            //modify the cell to add the text label
            cell.textLabel?.text = category.name ?? "No Categories added yet"
            
            guard let color = UIColor(hexString: category.cellColor) else {fatalError("Could not get a color for the cell")}
            
            cell.backgroundColor = color
            
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:color, isFlat:true)
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    

    
    //MARK: - Data Manipulation methods (save/load)
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving Category context: \(error)")
        }
        
        tableView.reloadData()
    }
    

    func loadCategories() {
        
        //returns datatype of realm Results (a container) containing a bunch of Category objects
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error deleting category, \(error)")
            }
            tableView.reloadData()
        }
        
    }

    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category()

            newCategory.name = textField.text!
            
            let cellColor = UIColor.randomFlat()
            let cellHex = cellColor?.hexValue()
            
            newCategory.cellColor = cellHex!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new Category"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}



