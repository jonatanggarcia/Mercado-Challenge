//
//  ProductViewController.swift
//  Mercado Challenge
//
//  Created by Jony on 19/12/2020.
//  Copyright © 2020 jony. All rights reserved.
//

import UIKit
import SDWebImage

class ProductViewController: UIViewController {
    
    //selectedProduct es optional porque va a ser nil hasta ser seteado en SearchViewController
    var selectedProduct: ProductModel?
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productCondition: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImage.sd_setImage(with: URL(string: selectedProduct!.MainDetails.productImageURL))
        productCondition.text = selectedProduct?.condition
        productTitle.text = selectedProduct?.MainDetails.title
        productPrice.text = selectedProduct?.MainDetails.productPrice
        productQuantity.text = "Cantidad disponible: \(selectedProduct?.available_quantity ?? "1")"
    }
    
    @IBAction func buyButtonPressed(_ sender: UIBarButtonItem) {
        
        //Pop-Up del botón comprar
        let alert = UIAlertController(title: "Mercado Challenge Demo", message: "Para realizar compras descarga la App de Mercado Libre desde App Store y feliz compra!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        
        //Mostrar el Pop-up
        present(alert, animated: true, completion: nil)
    }
}
