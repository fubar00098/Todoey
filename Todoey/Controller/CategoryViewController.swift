//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Spoke on 2018/1/6.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //連接coreData
    var cateGoryArray = [Category]()
    
    
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("cateGory.plist")
    
    //created core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

       
    }
    
    //MARK: - TableView Datasource Methods
    /****************************************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateGoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = cateGoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    /****************************************/

    func saveCategories(){
        
        do{
        try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    func loadCategories(){
        
       let reques: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        cateGoryArray = try context.fetch(reques)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Categories
    /****************************************/
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
       let alert =  UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Here", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert

            print(textField.text!)
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.cateGoryArray.append(newCategory)
            
            self.saveCategories()
            
            
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add a new Category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    /****************************************/

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       
        //this will identify the current row that is selected (option binding)
        //選到的cell如果有值，就利用selectedCategory 從ToDoList儲存該cell的資料進來
        if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = cateGoryArray[indexPath.row]
            
        }
        
    }
        

}
