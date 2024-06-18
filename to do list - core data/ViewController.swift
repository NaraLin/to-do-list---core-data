//
//  ViewController.swift
//  to do list - core data
//
//  Created by 林靖芳 on 2024/6/17.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    var models = [ToDoListItem]()
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = models[indexPath.row]
        deleteItem(item: item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //點選row不會一直反灰
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit/Delete", message: nil, preferredStyle: .actionSheet)
        
        //Edit
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {[weak self] _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit Your Item", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "save", style: .default, handler: { _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
                
            }))
            
            self?.present(alert, animated: true)
        }))
        
        //Delete
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteItem(item: item)
        }))
        
        //Cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true)
    }
                        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as! ToDoTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: model.createdAt!)
        cell.dateLabel.text = dateString
        cell.toDoLabel.text = model.name
        return cell
        
    }
    
    //NSManagedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView:UITableView = {
       let table = UITableView()
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        table.register(nib,
                       forCellReuseIdentifier: "ToDoTableViewCell")
       return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
        
        //開啟APP時，從persistent stores抓取資料
        getAllItems()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(didTapAdd))
    }

    @objc func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "submit", style: .default, handler: { [weak self]_ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
            
        }))
        
        present(alert, animated: true)
    }

    
    
    //Core Data
    
    func getAllItems(){
        do{
            //抓取所有使用ToDoList class建立的物件，更新表格
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            //error
        }
    }
    
    
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
  
    }
    
    
    func deleteItem(item:ToDoListItem){
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
        
    }
    
    
    
    
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
        
    }
    
    
}

