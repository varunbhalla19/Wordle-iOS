//
//  KeyBoardViewController.swift
//  Wordle-iOS
//

import UIKit
import ReSwift

class KeyBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var returnKey: Character = "⮑"
    lazy var clear: Character = "╳"
    
    lazy var letters = ["qwertyuiop", "asdfghjkl","\(returnKey)zxcvbnm\(clear)"]
    
    lazy var keys: [[Character]] = {
        letters.map({ Array($0) })
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCellCollectionViewCell.self, forCellWithReuseIdentifier: KeyCellCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    

}

extension KeyBoardViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCellCollectionViewCell.identifier, for: indexPath) as? KeyCellCollectionViewCell else {
            fatalError("can't find KeyCellCollectionViewCell")
        }
        let letter = keys[indexPath.section][indexPath.row]
        let uppercasedLetter = Character(String(letter).uppercased())
        cell.label.textColor = gameStore.state.usedChars.getKeyColor(for: uppercasedLetter)
        cell.transform = gameStore.state.usedChars.isInvalid(char: uppercasedLetter) ? .init(scaleX: 0.9, y: 0.9) : .identity
        cell.config(letter: letter, gameStore.state.usedChars.isInvalid(char: uppercasedLetter))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        
        let size = ( collectionView.frame.width - margin )/10
        
        return CGSize(width: size, height: size * 1.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let margin = CGFloat(20)
        let width: CGFloat = ( collectionView.frame.width - margin ) / 10
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let inset: CGFloat = (collectionView.frame.width - (width*count) - (2*count))/2
        
        return UIEdgeInsets(top: 4, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        
        let char = keys[indexPath.section][indexPath.row]
        if gameStore.state.usedChars.isInvalid(char: Character(String(char).uppercased())) {
            return;
        }
        
        if char == returnKey {
            if gameStore.state.guessState.isRowComplete {
                gameStore.dispatch(GameAction.lineEnded)
            }
            return
        }
        
        if char == clear {
            gameStore.dispatch(GameAction.backSpace)
            return
        }
        
        if gameStore.state.guessState.isRowComplete {
            return;
        }
        
        let upperCased = Character(char.uppercased())
        gameStore.dispatch(GameAction.addChar(upperCased))
    }
}


extension KeyBoardViewController: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameStore.unsubscribe(self)
    }
    
    func newState(state: GameState) {
        collectionView.reloadData()
    }
    
    typealias StoreSubscriberStateType = GameState
    
    
}
