//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Natalija Mitic on 26.08.19.
//  Copyright © 2019 Natalija Mitic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.colorHex) else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
      
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods (save/load)
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
    }

    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //when "add" clicked
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.dateCreated = Date()
            newCategory.colorHex = UIColor(randomColorIn: [FlatRed(), FlatOrange(), FlatYellow(), FlatSand(), FlatMagenta(), FlatTeal(), FlatSkyBlue(), FlatGreen(), FlatMint(), FlatWhite(), FlatForestGreen(), FlatPurple(), FlatPlum(), FlatWatermelon(), FlatPink(), FlatCoffee(), FlatPowderBlue(), FlatBlue()])!.hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Add Reorganize Lines function
    
}
