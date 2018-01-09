//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Spoke on 2018/1/6.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    //連接Realm
    let realm = try! Realm()
    
    //變更data type to realm Resulm, (會auto update)
    var cateGoryArray: Results<Category>!
    
    
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("cateGory.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()

       
    }
    
    //MARK: - TableView Datasource Methods
    /****************************************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Used "Nil Coalescing operator" to define what's to do if cateGoryAttay is nil
        return cateGoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //Used "Nil Coalescing operator" to define what's to do if cateGoryAttay is nil
        cell.textLabel?.text = cateGoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    /****************************************/

    func save(category: Category){
        
        do{
            //realm.write it's like update
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    func loadCategories(){
        
        //pull out all of the items inside our realm in Category Object
        //要注意，在realm 儲存傳回的是Results,所以要去開頭更改data type
         cateGoryArray = realm.objects(Category.self)
        

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
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
            
            
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
                destinationVC.selectedCategory = cateGoryArray?[indexPath.row]
            
        }
        
    }
        

}
