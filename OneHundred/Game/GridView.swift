//
//  GridView.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 02/01/2019.
//  Copyright © 2019 fabfer_dev. All rights reserved.
//

import UIKit

protocol GridViewDelegate: class {
    func gridView(_ gridView: GridView, didTapOnButton button: Button)
}

final class GridView: UIView {
    
    weak var delegate: GridViewDelegate?
    
    private var grid: UIStackView!
    
    private var numberOfRows: Int!
    private var numberOfColumns: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    func configure(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        
        grid = UIStackView()
        self.addSubview(grid)
        
        grid.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        grid.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        grid.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        grid.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        var cellCount = 0
        
        for _ in 0..<numberOfRows {
            let stackView = UIStackView()
            for _ in 0..<numberOfColumns {
                let button = Button()
                button.layer.cornerRadius = 2
                button.backgroundColor = Colors.inactive
                button.accessibilityIdentifier = String(cellCount)
                cellCount += 1
                button.addTarget(self, action: #selector(tapCell(_:)), for: UIControl.Event.touchUpInside)
                stackView.addArrangedSubview(button)
            }
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 5.0
            stackView.translatesAutoresizingMaskIntoConstraints = false
            grid.addArrangedSubview(stackView)
        }
        
        grid.axis = .vertical
        grid.alignment = .fill
        grid.distribution = .fillEqually
        grid.spacing = 5.0
        grid.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Actions
    
    @objc func tapCell(_ button: Button) {
        delegate?.gridView(self, didTapOnButton: button)
    }
}

// MARK: - API

extension GridView {
    
    /// Returns the button in the view that is related to the given cell in the model.
    func button(for cell: GridCell) -> Button {
        let stackView = grid.arrangedSubviews[cell.row] as! UIStackView
        let cellButton = stackView.arrangedSubviews[cell.column] as! Button
        return cellButton
    }
    
    func reset() {
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let stackView = grid.arrangedSubviews[row] as! UIStackView
                let button = stackView.arrangedSubviews[column] as! Button
                button.backgroundColor = Colors.inactive
                button.setTitle("", for: .normal)
            }
        }
    }
}
