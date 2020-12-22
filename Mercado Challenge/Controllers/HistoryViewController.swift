//
//  HistoryViewController.swift
//  Mercado Challenge
//
//  Created by Jony on 18/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    private var searchArray: [String]?
    
    //Se crea una instancia de UserDefaults para acceder a los registros del historial guardados dentro.
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Carga el array con los datos dentro de UserDefaults
        if let searches = defaults.array(forKey: K.defaultsHistoryKey) as? [String] {
            searchArray = searches
        }
        
        tableView.allowsSelection = false
        
        //Elimina los separadores entre las celdas
        tableView.separatorStyle = .none
    }
    
    //Vaciar el historial
    @IBAction func clearBrowsingData(_ sender: UIBarButtonItem) {
        
        //Pop-Up del botón Trash
        let alert = UIAlertController(title: "Vaciar historial", message: "¿Seguro desea borrar el historial?", preferredStyle: .alert)
        
        //Lo que sucede cuando el usuario clickee en Eliminar
        let delete = UIAlertAction(title: "Eliminar", style: .default) { (action) in
            
            //Se marca como self por estar dentro de un Closure
            self.searchArray = nil
            self.defaults.removeObject(forKey: K.defaultsHistoryKey)
            
            //Llama los Tableview Datasource Methods de nuevo
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .default)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        //Mostrar el Pop-up
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Methods
    
    //Retorna la cantidad de celdas que necesito
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //En caso de que searchArray sea nil retorna 1 | nil coalescing operator
        return searchArray?.count ?? 1
    }
    
    //Insertar las celdas con los datos en la posición que deben
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.historyCellIdentifier, for: indexPath)
        
        //En caso de que searchArray sea nil retorna un texto | nil coalescing operator
        cell.textLabel?.text = searchArray?[indexPath.row] ?? "No hay búsquedas recientes en el historial"
        
        return cell
    }
}
