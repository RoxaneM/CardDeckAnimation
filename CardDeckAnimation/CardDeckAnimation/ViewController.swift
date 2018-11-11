//
//  ViewController.swift
//  CardDeckAnimation
//
//  Created by Roxane Gud on 11/11/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var deckContainer: DeckAnimationContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        deckContainer.setCards(cardsArray)
    }



}

