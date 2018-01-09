//
//  TodoListViewController
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet {
            loadItems()
        }
    }
    
    
    //created our own plist at location data file path instead use UserDefaults
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //因為重複使用cell 造成checkMark重複出現,所以使用dictionary增加一個checkMark 檢查用，並使用mvc
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        


//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//        itemArray = items
//
//        }
        
    }
        
    

    //Mark: - Tableview Datasource methods
    /***************************************************************/


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //確保如果沒有抓到資料 app不會崩潰
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            
            //Ternary operatoe ==>
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
            
            //        if item.done == true {
            //
            //            cell.accessoryType = .checkmark
            //        }else {
            //
            //            cell.accessoryType = .none
            //        }
            
        }else {
            cell.textLabel?.text = "No Items Added"
            
        }

        return cell
    }
    
    

    //Mark: - TableView Delegate Methods
    //***************************************************************//

    
    //感應TableView觸碰的方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //選取後的反黑會消失
        tableView.deselectRow(at: indexPath, animated: true)
        
        //如果有值，則把選取的cell存到item裡，todoItems就是Results<Item>
        if let item = todoItems?[indexPath.row] {
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
            tableView.reloadData()
    }
    
    
    
    
    //MARK: - Add New Items
    /***************************************************************/

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //use Global variable that alertTextfield can available show in UIAlertAction
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert
            print(TextField.text!)
            

            //selectedCategory可能有值或沒有 
            if let currentCategory = self.selectedCategory {
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = TextField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Creat new item"
            TextField = alertTextfield
            
        }
    
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    

    //MARK: - Model Manupulation Methods (Codeable)
    /***************************************************************/
    
    
    // = Item.fetchRequest() is a default value where we didn't giving it any parameters
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

        }


}

//Mark: - Search bar methods
/***************************************/

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

//        //in order to read from the context we always have to create a request
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //sort the data we get back from the database
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)


    


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //that Xcode to grab this resign method in the main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

