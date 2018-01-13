//
//  TodoListViewController
//  Todoey
//
//  Created by Spoke on 2017/12/31.
//  Copyright © 2017年 Spoke. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category?{
        didSet {
            loadItems()
        }
    }
    
    
    //created our own plist at location data file path instead use UserDefaults
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        
        
        tableView.separatorStyle = .none

        
    }
    
    //this code get caled just after viewDidLoad and show on the screen before.
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name

        guard let colourHex = selectedCategory?.cellColor else { fatalError()}
        
        updateNavBar(withHexCode: colourHex)
        

    }
    
    //當螢幕將要結束時呼叫，把顏色設為原本的藍色
    
//    override func viewWillDisappear(_ animated: Bool) {
//       updateNavBar(withHexCode: "0080FF")
//    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        updateNavBar(withHexCode: "0080FF")
    }
        
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
         //set value if the current navigationBar in the current navigationContriller, if it's nil than will crash than inform ourselves
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        
        //按鈕顏色
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        //字體顏色
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
        
    

    //Mark: - Tableview Datasource methods
    /***************************************************************/


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //確保如果沒有抓到資料 app不會崩潰
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title

            if let colour = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)

            }
            
//            print("version1: \(CGFloat(indexPath.row / todoItems!.count))")
//            print("version2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")

            
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
    
    
    
    //MARK: - Delete Data From Swipe
    /****************************************/
    
    override func updateMode(at indexPath: IndexPath) {
        
        if let toDoListForDeletion = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(toDoListForDeletion)
                }
                }catch{
                    print("Error deleting ToDoList \(error)")
            }
        }
        
    }
    
    
    
    
    //MARK: - Add New Items
    /***************************************************************/

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //use Global variable that alertTextfield can available show in UIAlertAction
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let canCelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
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
            alertTextfield.placeholder = "Creat new Item"
            TextField = alertTextfield
            
        }
        
        alert.addAction(canCelAction)
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
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
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

