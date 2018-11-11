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
    
    override func layoutSubviews() {
        updateTopCardFrame()
        layoutCards()
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
            originalCardRatio = topCardView.frame.width / topCardView.frame.height
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
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTapGR(_:)))
//        addGestureRecognizer(tapGR)
    }
    
    @objc private func handleTapGR(_ tapGR: UITapGestureRecognizer) {
        let touchLocation = tapGR.location(in: self)
        
        if touchLocation.y < frame.height / 2 {
            showNextCard()
        } else {
            showPreviousCard()
        }
    }
    
    private var firstTouchPoint = CGPoint.zero
    private var lastSavedTouchPoint = CGPoint.zero
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            firstTouchPoint = touch.location(in: self)
            lastSavedTouchPoint = firstTouchPoint
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }

        animateOnMove(newTouchPoint: touchPoint)
        lastSavedTouchPoint = touchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let topCardView = cards[topCardIndex] as? UIView else { return }
        topCardView.alpha = 1.0
        
        let dy = firstTouchPoint.y - lastSavedTouchPoint.y
        if dy < 0 { //swipe down
            showPreviousCard()
        } else { // swipe up
            showNextCard()
        }
        
        firstTouchPoint = CGPoint.zero
        lastSavedTouchPoint = CGPoint.zero
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
    
    private func animateOnMove(newTouchPoint: CGPoint) {
        guard let topCardView = cards[topCardIndex] as? UIView else { return }
        
        let dyMaxRecognition: CGFloat = 100.0
        let dy = firstTouchPoint.y - newTouchPoint.y
        
        let dyAbs = min(abs(dy), dyMaxRecognition)
        let alphaIntensity = 1.0 - dyAbs / dyMaxRecognition

        topCardView.alpha = 0.5 + alphaIntensity/2 //force it into range [0.5; 1.0]
        
        if dy < 0 { //swipe down
            
        } else { // swipe up
            
        }
    }
    
    // MARK: - Layout
    private var topCardFrame: CGRect = CGRect.zero
    private var originalCardRatio: CGFloat = 1.0 // width to height relation
    
    private func layoutCards() {
        for index in 0 ..< cards.count {
            if let cardView = cards[index] as? UIView {
                
                let currentOrderPosition = index - topCardIndex < 0 ?
                    index - topCardIndex + cards.count :
                    index - topCardIndex
                
                cardView.frame = cardFrame(at: currentOrderPosition)
            }
        }
    }

    private func cardFrame(at orderPosition: Int) -> CGRect {
        let cardLevelInset: CGFloat = 10.0
        
        let cardLevel = orderPosition < cardsVisibleDepth ? orderPosition : cardsVisibleDepth - 1
        let cardInset = cardLevelInset * CGFloat(cardLevel)
        
        var cardFrame = topCardFrame.insetBy(dx: cardInset, dy: cardInset)
        cardFrame.origin.y = (topCardFrame.maxY + cardInset) - cardFrame.height
        
        return cardFrame
    }
    
    private func updateTopCardFrame() {
        let minEdgeInset: CGFloat = 10.0

        //only fitting by width for now
        let calculatedWidth = frame.width - (2.0 * minEdgeInset)
        let calculatedHeight = calculatedWidth / originalCardRatio
        
        topCardFrame = CGRect(x: minEdgeInset, y: minEdgeInset, width: calculatedWidth, height: calculatedHeight)
    }

}
