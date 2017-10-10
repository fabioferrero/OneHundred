//
//  GameGrid.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

class GameGrid
{
    let numberOfRows: Int
    let numberOfColumns: Int
    
    // Arrays of arrays for implementing the matrix
    private var mainGrid: [GridCell?]
    
    init?(withRows numberOfRows: Int, andColumns numberOfColumns: Int)
    {
        guard numberOfRows > 0 && numberOfColumns > 0 else {
            return nil
        }
        
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        
        // Matrix Initialization
        mainGrid = Array<GridCell?>(repeating: nil, count: numberOfRows * numberOfColumns)
        for rowIndex in 0..<numberOfRows {
            for columnIndex in 0..<numberOfColumns {
                // In this case bounds are not checked
                mainGrid[matrixIndex(rowIndex, columnIndex)] = GridCell(atRow: rowIndex, andColumn: columnIndex, inGrid: self)
            }
        }
    }
    
    func possibleCells(forCell cell: GridCell) -> [GridCell] // It supposes the cell being in the grid
    {
        var cellArray = [GridCell]()
        if let possibleCell = cell.diagonal(.upLeft)?.diagonal(.upLeft) {
            cellArray.append(possibleCell)  // top-left
        }
        if let possibleCell = cell.up()?.up()?.up() {
            cellArray.append(possibleCell)  // up
        }
        if let possibleCell = cell.diagonal(.upRight)?.diagonal(.upRight) {
            cellArray.append(possibleCell)  // top-right
        }
        if let possibleCell = cell.right()?.right()?.right() {
            cellArray.append(possibleCell)  // right
        }
        if let possibleCell = cell.diagonal(.downRight)?.diagonal(.downRight) {
            cellArray.append(possibleCell)  // down-right
        }
        if let possibleCell = cell.down()?.down()?.down() {
            cellArray.append(possibleCell)  // down
        }
        if let possibleCell = cell.diagonal(.downLeft)?.diagonal(.downLeft) {
            cellArray.append(possibleCell)  // down-left
        }
        if let possibleCell = cell.left()?.left()?.left() {
            cellArray.append(possibleCell)  // left
        }
        return cellArray
    }
    
    func forAllCellsPerform(_ action: (GridCell) -> ()) {
        for element in mainGrid {
            if let cell = element {
                action(cell)
            }
        }
    }
    
    private func isValidCellIndex(row: Int, column: Int) -> Bool
    {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    private func matrixIndex(_ row: Int, _ column: Int) -> Int {
        return row * numberOfColumns + column
    }
    
    // Subscript syntax for calls as grid[row, column]
    subscript(row: Int, column: Int) -> GridCell?
    {
        get {
            if isValidCellIndex(row: row, column: column) {
                return mainGrid[matrixIndex(row, column)]
            } else {
                return nil
            }
        }
        set {
            if isValidCellIndex(row: row, column: column) {
                mainGrid[matrixIndex(row, column)] = newValue
            }
        }
    }
    
    // Subscript syntax for calls as grid[position] with position as tuple (row, column)
    subscript(position: (row: Int, column: Int)) -> GridCell?
    {
        get {
            let newRow = position.row
            let newColumn = position.column
            if isValidCellIndex(row: newRow, column: newColumn) {
                return mainGrid[matrixIndex(newRow, newColumn)]
            } else {
                return nil
            }
        }
        set {
            let newRow = position.row
            let newColumn = position.column
            if isValidCellIndex(row: newRow, column: newColumn) {
                mainGrid[matrixIndex(newRow, newColumn)] = newValue
            }
        }
    }
    
    func cellAt(sequentialIndex index: Int) -> GridCell?
    {
        if index >= numberOfRows * numberOfColumns ||
            index < 0 {
            return nil
        }
        return mainGrid[index]
    }
    
    func cellAt(sequentialIdentifier id: String) -> GridCell?
    {
        guard let index = Int(id) else {
            print("Impossible to translate index from string")
            return nil
        }
        if index >= numberOfRows * numberOfColumns ||
            index < 0 {
            return nil
        }
        return mainGrid[index]
    }
    
}
