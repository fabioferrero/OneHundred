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
    
    private func isValidCellIndex(row: Int, column: Int) -> Bool
    {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    private func matrixIndex(_ row: Int, _ column: Int) -> Int {
        return row * numberOfColumns + column
    }
    
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
    
}
