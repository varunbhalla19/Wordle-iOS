//
//  KeyCellCollectionViewCell.swift
//  Wordle-iOS
//

import UIKit

class KeyCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "KeyCellCollectionViewCell"
    
    var isReadOnly = true
    
    let label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        isReadOnly = true
    }
    
    func config(letter: Character, _ readOnly: Bool = true){
        label.text = String(letter).uppercased()
        isReadOnly = readOnly
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard !isReadOnly else { return }
            UIView.animate(withDuration: 0.2) {
                if self.isHighlighted {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                } else {
                    self.transform = .identity
                }
            }
        }
    }
    
}
