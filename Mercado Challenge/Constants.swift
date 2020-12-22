//
//  Constants.swift
//  Mercado Challenge
//
//  Created by Jony on 21/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import Foundation


//Para evitar errores al escribir
//y en caso de cambiar alguno de los siguientes parametros hacerlo en un solo lugar

//K por convención es lo mismo que Constants
struct K {
    
    //Se agraga la key "static" para poder acceder al valor sin necesidad de crear un objet | Type Property
    static let searchCellIdentifier = "SearchItemCell"
    static let historyCellIdentifier = "HistoryCell"
    static let productSegue = "goToProduct"
    static let historySegue = "goToHistory"
    static let defaultsHistoryKey = "SearchHistory"
    static let cellNibName = "ProductCell"
    static let cellProductIdentifier = "ReusableCell"
    
}
