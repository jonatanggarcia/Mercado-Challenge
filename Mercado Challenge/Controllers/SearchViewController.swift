//
//  ViewController.swift
//  Mercado Challenge
//
//  Created by Jony on 18/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UITableViewController {
    
    //ProductManager encargado de Networking e interactuar con la API de Mercado Libre
    private var productManager = ProductManager()
    
    //Donde se va a cargar la lista de productos
    private var productList: [ProductModel]?
    
    //Se usa UserDefaults para guardar los registros de la búsqueda.
    //Se eligió UserDefaults ya que es solo texto y ocupa pocos KB.
    private let defaults = UserDefaults.standard
    
    private var itemArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se establece como el delegate para poder implementar los métodos dentro de protocol
        productManager.delegate = self
        
        //Los custom xib files tienen que ser registrados en viewDidLoad
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.searchCellIdentifier)
        
    }
    
    //MARK: - TableView DataSource Methods
    
    //Retorna la cantidad de celdas que necesito
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //En caso de que productList sea nil retorna 0 | nil coalescing operator
        return productList?.count ?? 0
    }
    
    //Insertar las celdas con los datos en la posición que deben
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.searchCellIdentifier, for: indexPath) as! ProductCell
        
        if let product = productList?[indexPath.row] {
            //cell.textLabel?.text = product.MainDetails.title
            cell.titleLabel.text = product.MainDetails.title
            cell.priceLabel.text = product.MainDetails.productPrice
            cell.productImageView.sd_setImage(with: URL(string: product.MainDetails.productImageURL))
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //Método que va a ser llamado cuando se clickee en una Cell de la TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemArray != nil {
            //Va al Product Page
            performSegue(withIdentifier: K.productSegue, sender: self)
        }
    }
    
    //Método que va a ser llamado justo antes de performSegue | Preparativos
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.productSegue {
            //Referencia al VC destino
            //Se hace un down cast "as!" porque se conoce el VC destino
            let destinationVC = segue.destination as! ProductViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedProduct = productList?[indexPath.row]
            }
        }
        
    }
    
    //MARK: - History
    
    //Va al historial
    @IBAction func historyButtonPressed(_ sender: UIBarButtonItem) {
        
        //Segue hacia HistoryViewController
        performSegue(withIdentifier: K.historySegue, sender: self)
    }
    
}

//MARK: - SearchBar Delegate Methods

extension SearchViewController: UISearchBarDelegate {
    
    //Método que va a ser llamado cuando se clickee en el boton buscar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count != 0 {
            
            //En caso borrar el historial y que defaults este vacío se carga de nuevo el Array - Refresh
            if let items = defaults.array(forKey: K.defaultsHistoryKey) as? [String] {
                itemArray = items
                //Se hace force unwrap porque ya se sabe que no es nil
                itemArray!.insert(searchBar.text!, at: 0)
            } else {
                itemArray = [searchBar.text!]
            }
            
            defaults.set(itemArray, forKey: K.defaultsHistoryKey)
            
            //Única llamada a la función fetchProduct de productManager para obtener la lista de productos
            //Se hace force unwrap porque ya se sabe que no es nil
            
            productManager.fetchProduct(productName: searchBar.text!)
            
            /*
             Dependiendo del resultado del método fetchProduct, se va a llamar
             a uno de estos métodos:
             
             didUpdateProductList(_ productManager: ProductManager, product: ProductModel)
             didFailWithError(error: Error)
             
             tableView.reloadData() se encuentra dentro de didUpdateProductList
             
             */
            
        } else {
            searchBar.placeholder = "Ingrese lo que desea buscar"
        }
        
    }
    
    //Método que va a ser llamado cada vez que cambie el texto en Searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            //Agarra el thread principal, lugar donde se debe actualizar lo que es UI
            DispatchQueue.main.async {
                
                //Deja de ser el primero en responder | Objetivo: Ocultar el teclado y el cursor
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//MARK: - ProductManager Delegate Methods

//Estos métodos son llamados dentro de ProductManager
extension SearchViewController: ProductManagerDelegate {
    
    func didUpdateProductList(_ productManager: ProductManager, products: [ProductModel]) {
        
        productList = products
        
        //Llama a los Tableview Datasource Methods de nuevo
        tableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        
        print("Error al intentar actualizar la lista de productos: \(error)")
        
        //Pop-Up de Error
        let alert = UIAlertController(title: "Lo sentimos, ha ocurrido un error", message: "Por favor revisa tu conexión a internet o intenta más tarde", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        
        //Mostrar el Pop-up
        present(alert, animated: true, completion: nil)
        
    }
}
