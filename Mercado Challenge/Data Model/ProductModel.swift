//
//  ProductModel.swift
//  Mercado Challenge
//
//  Created by Jony on 21/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import Foundation

struct ProductModel {
    let MainDetails: ProductMainDetails
    let available_quantity: String
    let condition: String
}

struct ProductMainDetails {
    let title: String
    let price: String
    let currency_id: String
    let imageURL: String
    
    var productPrice: String {
        return "\(price) \(currency_id)"
    }
    
    var productImageURL: String {
        //Se agrega "s" a http para poder acceder al valor al hacerlo seguro
        var safeImageURL = imageURL
        safeImageURL.insert("s", at: safeImageURL.index(safeImageURL.startIndex, offsetBy: 4))
        return safeImageURL
    }
}
