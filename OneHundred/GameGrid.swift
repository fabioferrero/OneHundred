//
//  GameGrid.swift
//  OneHundred
//
//  Created by Fabio Ferrero on 07/10/17.
//  Copyright © 2017 fabfer_dev. All rights reserved.
//

import Foundation

/**
 A grid model that contains instances of GridCells class.
 */
class GameGrid
{
    /**
     The number of rows in the grid.
     */
    let numberOfRows: Int
    
    /**
     The number of columns in the grid.
     */
    let numberOfColumns: Int
    
    /**
     The internal array that implements the matrix layout.
     */
    private var mainGrid: [GridCell?]
    
    /**
     Create a new GameGrid with specified numberOfRows and numberOfColumns.
     */
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
                mainGrid[matrixIndex(rowIndex, columnIndex)] = GridCell(atRow: rowIndex, andColumn: columnIndex, inGrid: self)
            }
        }
    }
    
    /**
     Returns a collection of cells that are reacheables from the cell parameter.
     */
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
    
    /**
     Perform the same action on all cell inside the grid.
     */
    func forAllCellsPerform(_ action: (GridCell) -> ()) {
        for element in mainGrid {
            if let cell = element {
                action(cell)
            }
        }
    }
    
    /**
     Returns the cell at the specified sequentialIndex inside the grid.
     */
    func cellAt(sequentialIndex index: Int) -> GridCell?
    {
        if index >= numberOfRows * numberOfColumns || index < 0 {
            return nil
        }
        return mainGrid[index]
    }
    
    /**
     Returns the cell that corresponds to the sequentialIdentifier inside th grid.
     */
    func cellAt(sequentialIdentifier id: String) -> GridCell?
    {
        guard let index = Int(id) else {
            print("Impossible to translate index from string")
            return nil
        }
        if index >= numberOfRows * numberOfColumns || index < 0 {
            return nil
        }
        return mainGrid[index]
    }
    
    /**
     Check the validity of the given coordinates for a cell inside the grid.
     */
    private func isValidCellIndex(row: Int, column: Int) -> Bool
    {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    /**
     Translate 2D coordinate (row, column) into the sequential index for accessing the internal array.
     */
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
}

