//
//  DeckAnimationContainer.swift
//  CodewarsSheet
//
//  Created by Roxane Gud on 11/11/18.
//  Copyright © 2018 Roxane Markhyvka. All rights reserved.
//

import UIKit

protocol DeckCard where Self: UIView {
    var view: UIView { get }
    
    //func getIndex() -> Int
}

extension DeckCard {
    var view: UIView {
        return self as UIView
    }
//
//    func getIndex() -> Int { return self.tag }
}

class DeckAnimationContainer: UIView {
    
    private var cards = [DeckCard]()
    private var topCardIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    // MARK: - Public
    func setCards(_ newCards: [DeckCard]) {
        cards = newCards
        
        for card in newCards.reversed() {
            //_ = card.view
            if let cardView = card as? UIView {
                cardView.frame = frame(for: card, at: 0)
                addSubview(cardView)
            }
        }
        
        topCardIndex = 0
    }
    
    func addCard(_ card: DeckCard) {
        cards.append(card)
    }
    
    func addCards(_ newCards: [DeckCard]) {
        cards.append(contentsOf: newCards)
    }
    
    func removeAllCards() {
        cards.removeAll()
    }
    
    // MARK: - Private
    
    private var nextCardIndex: Int {
        let nextIndex = topCardIndex + 1
        return nextIndex < cards.count ? nextIndex : 0
    }
    
    private var previousCardIndex: Int {
        let previousIndex = topCardIndex - 1
        return previousIndex < 0 ? cards.count - 1 : previousIndex
    }
    
    private func setup() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTapGR(_:)))
        addGestureRecognizer(tapGR)
    }
    
    @objc private func handleTapGR(_ tapGR: UITapGestureRecognizer) {
        let touchLocation = tapGR.location(in: self)
        
        if touchLocation.y < frame.height / 2 {
            showNextCard()
        } else {
            showPreviousCard()
        }
    }
    
    private func showNextCard() {
        if let topCard = cards[topCardIndex] as? UIView {
            sendSubview(toBack: topCard)
            
            topCardIndex = nextCardIndex
        }
    }
    
    private func showPreviousCard() {
        if let previousCard = cards[previousCardIndex] as? UIView {
            bringSubview(toFront: previousCard)
            
            topCardIndex = previousCardIndex
        }
    }
    
    // MARK: - Layout
    private func frame(for card: DeckCard, at index: Int) -> CGRect {
        return bounds.insetBy(dx: 20.0, dy: 20.0)
    }

}
