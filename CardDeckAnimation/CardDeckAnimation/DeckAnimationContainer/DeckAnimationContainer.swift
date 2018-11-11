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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    // MARK: - Public
    var cardsVisibleDepth: Int = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    func setCards(_ newCards: [DeckCard]) {
        cards = newCards
        
        if let topCardView = cards.first as? UIView {
            updateTopCardFrame(basedOn: topCardView.frame.size)
        }
        
        for card in newCards.reversed() {
            //_ = card.view
            if let cardView = card as? UIView {
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
    private var cards = [DeckCard]()
    
    private var topCardIndex = 0
    
    private var nextCardIndex: Int {
        let nextIndex = topCardIndex + 1
        return nextIndex < cards.count ? nextIndex : 0
    }
    
    private var previousCardIndex: Int {
        let previousIndex = topCardIndex - 1
        return previousIndex < 0 ? cards.count - 1 : previousIndex
    }
    
    // MARK: Gesture recognizer
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
    
    // MARK: - Animation
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
    override func layoutSubviews() {
        for index in 0 ..< cards.count {
            if let cardView = cards[index] as? UIView {
                
                let currentOrderPosition = index - topCardIndex < 0 ?
                    index - topCardIndex + cards.count :
                    index - topCardIndex
                
                cardView.frame = cardFrame(at: currentOrderPosition)
            }
        }
    }
    
    private var topCardFrame: CGRect = CGRect.zero
    
    private func cardFrame(at orderPosition: Int) -> CGRect {
        let cardLevelInset: CGFloat = 10.0
        
        let cardLevel = orderPosition < cardsVisibleDepth ? orderPosition : cardsVisibleDepth
        let cardInset = cardLevelInset * CGFloat(cardLevel)
        
        var cardFrame = topCardFrame.insetBy(dx: cardInset, dy: cardInset)
        cardFrame.origin.y = (topCardFrame.maxY + cardInset) - cardFrame.height
        
        return cardFrame
    }
    
    private func updateTopCardFrame(basedOn originalCardSize: CGSize) {
        let minEdgeInset: CGFloat = 10.0

        //only fitting by width for now
        let calculatedCardWidth = frame.width - (2.0 * minEdgeInset)
        let scaleCoef = calculatedCardWidth / originalCardSize.width
        let calculatedHeight = originalCardSize.height * scaleCoef
        
        topCardFrame = CGRect(x: minEdgeInset, y: minEdgeInset, width: calculatedCardWidth, height: calculatedHeight)
    }

}
