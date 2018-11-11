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
    
    private lazy var cardsArray: [CardView] = {
        let card1 = CardView.instanceFromNib(image: UIImage(named: "towerBridge"), text: "Tower Bridge is a combined bascule and suspension bridge in London built between 1886 and 1894. The bridge crosses the River Thames close to the Tower of London and has become an iconic symbol of London. Because of this, Tower Bridge is sometimes confused with London Bridge, situated some 0.5 mi (0.80 km) upstream. Tower Bridge is one of five London bridges now owned and maintained by the Bridge House Estates, a charitable trust overseen by the City of London Corporation.")
        card1.backgroundColor = .purple
        
        let card2 = CardView.instanceFromNib(image: UIImage(named: "londonEye"), text: "The London Eye is a giant Ferris wheel on the South Bank of the River Thames in London. It is Europe's tallest Ferris wheel,[10] is the most popular paid tourist attraction in the United Kingdom with over 3.75 million visitors annually,[11] and has made many appearances in popular culture. The structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft). When it opened to the public in 2000 it was the world's tallest Ferris wheel.")
        card2.backgroundColor = .cyan
        
        let card3 = CardView.instanceFromNib(image: UIImage(named: "westminster"), text: "The Palace of Westminster is the meeting place of the House of Commons and the House of Lords, the two houses of the Parliament of the United Kingdom. Commonly known as the Houses of Parliament after its occupants, the Palace lies on the north bank of the River Thames in the City of Westminster, in central London, England. Its name, which is derived from the neighbouring Westminster Abbey, may refer to either of two structures: the Old Palace, a medieval building complex destroyed by fire in 1834, or its replacement, the New Palace that stands today.")
        
        card3.backgroundColor = .yellow
        
        return [card1, card2, card3]
    }()


}

