//
//  CardView.swift
//  CodewarsSheet
//
//  Created by Roxane Gud on 11/11/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

class CardView: UIView, DeckCard {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    class func instanceFromNib(image: UIImage?, text: String) -> CardView {
        let view = Bundle.main.loadNibNamed("CardView", owner: nil, options: nil)![0] as! CardView
        view.imageView.image = image
        view.textLabel.text = text
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        let cornerRadius: CGFloat = 15.0
        layer.cornerRadius = cornerRadius
        
        clipsToBounds = true
    }
    
}
