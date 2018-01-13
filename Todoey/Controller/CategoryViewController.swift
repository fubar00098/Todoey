//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Spoke on 2018/1/6.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    
    //連接Realm
    let realm = try! Realm()
    
    //變更data type to realm Resulm, (會auto update)
    var cateGoryArray: Results<Category>?
    
    var colorIndex = ""
    
    let colorArray = ["FACE49", "E67F38", "ECEFF1", "F5A841", "D3542E", "F0DEB4", "D5C295", "53BD9D", "46A086", "B7C9F1", "99ABD5"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
       
    }
    
    //MARK: - TableView Datasource Methods
    /****************************************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Used "Nil Coalescing operator" to define what's to do if cateGoryAttay is nil
        return cateGoryArray?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //Used "Nil Coalescing operator" to define what's to do if cateGoryAttay is nil
        cell.textLabel?.text = cateGoryArray?[indexPath.row].name ?? "No Categories Added yet"
//
//        let cellColor = UIColor.randomFlat.hexValue()
//
        cell.backgroundColor = UIColor(hexString: cateGoryArray?[indexPath.row].cellColor ?? "0080FF")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (cateGoryArray?[indexPath.row].cellColor)!)!, returnFlat: true)
        
        
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    /****************************************/

    func save(category: Category){
        
        do{
            //realm.write it's like update(commit change)
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
    
    
    //MARK: - Delete Data From Swipe
    /****************************************/

    
    //this func can either call the superclass method or override it without the need for any of the superclass functionality
    override func updateMode(at indexPath: IndexPath) {
        if let categoryForDeletion = self.cateGoryArray?[indexPath.row]{

            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting catgory \(error)")
            }
        }
    }
    
    
    
    //MARK: - Add New Categories
    /****************************************/
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
       let alert =  UIAlertController(title: "Add a New ", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert

            print(textField.text!)
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            let randomIndex = Int(arc4random_uniform(UInt32(self.colorArray.count)))
            let colorIndex = self.colorArray[randomIndex]
            print(colorIndex)
            
            
           newCategory.cellColor = colorIndex
//            print(newCategory.cellColor)
            
            self.save(category: newCategory)
            
        }
        
        let canCelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add Here"
            textField = alertTextfield
        }
        
        
        alert.addAction(canCelAction)
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


    

