//
//  GameBoardViewController.swift
//  Wordle-iOS
//

import UIKit
import ReSwift

class GameBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCellCollectionViewCell.self, forCellWithReuseIdentifier: KeyCellCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    

}

extension GameBoardViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCellCollectionViewCell.identifier, for: indexPath) as? KeyCellCollectionViewCell else {
            fatalError("can't find KeyCellCollectionViewCell")
        }
        if let letter = gameStore.state.guessState.getChar(at: indexPath.section, row: indexPath.row) {
            cell.config(letter: letter)
        }
        cell.backgroundColor = gameStore.state.guessState.color(for: indexPath)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 40
        
        let size = ( collectionView.frame.width - margin ) / 5
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {        
        return UIEdgeInsets(top: 8, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected!!")
    }
    
    func reloadView(){
        collectionView.reloadData()
    }
}


extension GameBoardViewController: StoreSubscriber {
    
    func newState(state: GameState) {
        reloadView()        
    }
    
    typealias StoreSubscriberStateType = GameState
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameStore.unsubscribe(self)
    }

}
