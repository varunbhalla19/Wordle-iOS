//
//  ViewController.swift
//  Wordle-iOS
//

import UIKit

class ViewController: UIViewController {

    lazy var keyBoardVC = KeyBoardViewController()
    lazy var gameBoardVC = GameBoardViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        addChildren()
    }
    
    func addChildren(){
        addChild(keyBoardVC)
        keyBoardVC.didMove(toParent: self)
        keyBoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyBoardVC.view)
        
        addChild(gameBoardVC)
        gameBoardVC.didMove(toParent: self)
        gameBoardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameBoardVC.view)
        
        addCustomConstraints()
    }

    func addCustomConstraints(){
        NSLayoutConstraint.activate([
            gameBoardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameBoardVC.view.bottomAnchor.constraint(equalTo: keyBoardVC.view.topAnchor),
            gameBoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameBoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameBoardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            keyBoardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            keyBoardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyBoardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}


