//
//  ProductManager.swift
//  Mercado Challenge
//
//  Created by Jony on 21/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//Codigo reutilizable - Métodos que van a ser implementados dentro del TableViewController
protocol ProductManagerDelegate {
    func didUpdateProductList(_ productManager: ProductManager, products: [ProductModel])
    func didFailWithError(error: Error)
}

struct ProductManager {
    
    private let mercadoLibreArgURL = "https://api.mercadolibre.com/sites/MLA/search?"
    
    //TableViewController que la utilice se va asignar a si mismo como delegate
    var delegate: ProductManagerDelegate?
    
    //MARK: - Networking
    
    func fetchProduct(productName: String) {
        
        //Parametros
        let parameters: [String:String] = [
            //Query del producto
            "q": productName,
            //Orden de los productos por relevancia
            "sort" : "relevance",
            //Se limito la busqueda de productos a los primeros 10, solo para mostrar la funcionalidad
            "limit" : "10"
        ]
        
        performRequest(with: parameters)
    }
    
    private func performRequest(with parameters: [String:String]) {
        //Alamofire Request
        AF.request(mercadoLibreArgURL, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                //Analizar y utilizar JSON
                if let products = parseJSON(with: response) {
                    delegate?.didUpdateProductList(self, products: products)
                }
            
            case let .failure(error):
                delegate?.didFailWithError(error: error)
            }
        }
    }
    
    private func parseJSON(with response: AFDataResponse<Any>) -> [ProductModel]? {
        do {
            
            //Intenta convertir response (AFDataResponse) en JSON
            let productJSON = try JSON(response.result.get())
            
            var products: [ProductModel] = []
            
            //Al igual que el parametro limit de arriba, este 10 tambien esta hard coded, pero solo fue para mostrar la funcionalidad
            for i in 0..<10 {
                let title = productJSON["results"][i]["title"].stringValue
                let price = productJSON["results"][i]["price"].stringValue
                let currency_id = productJSON["results"][i]["currency_id"].stringValue
                let imageURL = productJSON["results"][i]["thumbnail"].stringValue
                let available_quantity = productJSON["results"][i]["available_quantity"].stringValue
                let condition = productJSON["results"][i]["condition"].stringValue
                
                //Product Model
                products.append(ProductModel(MainDetails: ProductMainDetails(title: title, price: price, currency_id: currency_id, imageURL: imageURL), available_quantity: available_quantity, condition: condition))
            }
            
            return products
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
