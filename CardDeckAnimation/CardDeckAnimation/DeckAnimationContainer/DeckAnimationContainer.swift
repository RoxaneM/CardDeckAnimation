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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    // MARK: - Override touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        firstTouchPoint = touchPoint
        lastSavedTouchPoint = touchPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self) else { return }
        
        animateOnMove(newTouchPoint: touchPoint)
        
        lastSavedTouchPoint = touchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let topCardView = cards[topCardIndex] as? UIView else { return }
        topCardView.alpha = 1.0

        animateOnEnded()
        
        firstTouchPoint = CGPoint.zero
        lastSavedTouchPoint = CGPoint.zero
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
    
    // MARK: - Animation
    private var firstTouchPoint = CGPoint.zero
    private var lastSavedTouchPoint = CGPoint.zero

    private func animateOnMove(newTouchPoint: CGPoint) {
        guard let topCardView = cards[topCardIndex] as? UIView else { return }
        
        // only dragging for 100 points up and 100 down will take effect, any exceeded paths will be muted
        let dyMaxRecognition: CGFloat = 100.0
        let dy = newTouchPoint.y - firstTouchPoint.y
        

        //changing alpha
        let dyAbs = min(abs(dy), dyMaxRecognition)
        let alphaIntensity = 1.0 - dyAbs / dyMaxRecognition
        topCardView.alpha = 0.5 + alphaIntensity/2 //force it into range [0.5; 1.0]
        
        //changing frames
        let dyMaxOriginMove: CGFloat = 30.0
        let moveCoef = dyMaxOriginMove / dyMaxRecognition
        let dyOriginMove = min(abs(dy * moveCoef), dyMaxOriginMove)
        
        var frame = topCardFrame
        frame.origin.y += dy > 0 ? dyOriginMove : -dyOriginMove
        topCardView.frame = frame
        
        if dy > 0 { //swipe down
            
        } else { // swipe up
            
        }
    }
    
    private func animateOnEnded() {
        let dy = lastSavedTouchPoint.y - firstTouchPoint.y
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            if dy > 0 { //swipe down
                self?.showPreviousCard()
            } else { // swipe up
                self?.showNextCard()
            }
            
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
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
