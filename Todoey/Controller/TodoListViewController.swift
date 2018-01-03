//
//  TodoListViewController
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //因為重複使用cell 造成checkMark重複出現,所以使用dictionary增加一個checkMark 檢查用，並使用mvc
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        itemArray = items
            
        }
        
    }
        
    
    
    //Mark- Tableview Datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //使用這個方法會創造出新的cell,mark過的cell離開銀幕後會再重新產生，不像dequeueReusableCell重複利用。
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        
        //因為重複使用cell 造成checkMark重複出現,所以把array改成使用dictionary增加一個checkMark 檢查用，並使用mvc 創造一個item Model
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
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

        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    
    //感應TableView觸碰的方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //選取後的反黑會消失
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //use opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//
//        if itemArray[indexPath.row].done == false {
//
//            itemArray[indexPath.row].done = true
//        }else{
//
//            itemArray[indexPath.row].done = false
//        }

        //forces the tableView to call data source method again
        
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //use Global variable that alertTextfield can available show in UIAlertAction
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert
            print(TextField.text!)
            
            let newItem = Item()
            newItem.title = TextField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Creat new item"
            TextField = alertTextfield
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    


}

