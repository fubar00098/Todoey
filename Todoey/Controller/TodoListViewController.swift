//
//  TodoListViewController
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet {
            loadItems()
        }
    }
    
    
    //created our own plist at location data file path instead use UserDefaults
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //使用.share(singleton) Object 得到進入AppDelegate class的權限 並使用.persistentContainer.viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    

    //Mark: - TableView Delegate Methods
    //***************************************************************//

    
    //感應TableView觸碰的方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //選取後的反黑會消失
        tableView.deselectRow(at: indexPath, animated: true)
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        //use opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //can use this to changed the cell title or done with forkey
//        itemArray[indexPath.row].setValue("Complete", forKey: "title")
        

//        if itemArray[indexPath.row].done == false {
//
//            itemArray[indexPath.row].done = true
//        }else{
//
//            itemArray[indexPath.row].done = false
//        }

        //forces the tableView to call data source method again
        
        
        saveItems()

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
            
            
            let newItem = Item(context: self.context)
            newItem.title = TextField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
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

    
    
    //set up the code to use core data for saving on new items
    func saveItems(){
        
        do {
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    // = Item.fetchRequest() is a default value where we didn't giving it any parameters
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //just a blank request than pulls back everything in our persistent container
        //use <> to specify what the data type of the output
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPreficate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPreficate])
        }else {
            request.predicate = categoryPredicate
        }
        
        
//        let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,categoryPredicate])
//
//        request.predicate = compoundpredicate
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching fata from context \(error)")
        }
        
        tableView.reloadData()

        }


}

//Mark: - Search bar methods
/***************************************/

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //in order to read from the context we always have to create a request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort the data we get back from the database
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)

        
    }

    
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
