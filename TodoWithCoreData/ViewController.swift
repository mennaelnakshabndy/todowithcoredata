//
//  ViewController.swift
//  TodoWithCoreData
//
//  Created by menna mostafa on 12/16/19.
//  Copyright © 2019 mennamostafa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate{

    
    @IBOutlet weak var tableview: UITableView!
    var itemName : [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "Title")
        
        do {
            
            itemName = try context.fetch(fetchRequest)
        }catch{
            print("error")
        }
        
    }
    
    var titleTextField : UITextField!
    
    func titleTextFieldText (textfield: UITextField!){
        
        titleTextField = textfield
        titleTextField.placeholder = "add items"
    }
    
    
    @IBAction func addItem(_ sender: Any)
    {
        let alert = UIAlertController(title: "todo List", message: "add your items ", preferredStyle: .alert)
        let saveaction = UIAlertAction(title: "save", style: .default, handler: self.save)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(saveaction)
        alert.addAction(cancel)
        alert.addTextField(configurationHandler: nil)
        alert.present(alert, animated: true, completion: nil)
  
    }
    
    
    func save(alert: UIAlertAction)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)
        let theTitle = NSManagedObject(entity: entity!, insertInto: context)
        theTitle.setValue(titleTextField, forKey: "title")
        
        do{
            try context.save()
            itemName.append(theTitle)
            
            
        }catch{
            print("there is an error in saving")
        }
        self.tableview.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = itemName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = title.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  UITableViewCellEditingStyle.delete {
            let appDelegte = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegte.persistentContainer.viewContext
            context.delete(itemName[indexPath.row])
            itemName.remove(at: indexPath.row)
            do{
                try context.save()
                
            }catch{
                print("there is an error")
            }
             self.tableview.reloadData()
        }
    }
    
    
}

