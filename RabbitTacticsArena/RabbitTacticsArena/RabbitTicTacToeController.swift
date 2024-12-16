//
//  TicTacToeViewController.swift
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//


import UIKit

class RabbitTicTacToeController: UIViewController {

    @IBOutlet var tapButtons: [UIButton]!
    @IBOutlet weak var xScoreLbl: UILabel!
    @IBOutlet weak var oScoreLbl: UILabel!
    @IBOutlet weak var turnLbl: UILabel!
    
    private var isXTurn = true
    private var xScore = 0
    private var oScore = 0
    private var board = [UIButton?](repeating: nil, count: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    @IBAction func tapButtons(_ sender: UIButton) {
        // Check if the button has already been tapped
        if board[sender.tag] != nil {
            print("Button at tag \(sender.tag) already tapped")
            return
        }

        // Set the image of the button based on the current turn
        if isXTurn {
            sender.setImage(UIImage(named: "green"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "red"), for: .normal)
        }

        // Update the board state
        board[sender.tag] = sender
        
        // Check for a win or tie
        if checkWin() {
            let winner = isXTurn ? "Green" : "Red"
            if isXTurn {
                xScore += 1
                xScoreLbl.text = "Green: \(xScore)"
            } else {
                oScore += 1
                oScoreLbl.text = "Red: \(oScore)"
            }
            turnLbl.text = "\(winner) Wins!"
            disableButtons()
        } else if board.allSatisfy({ $0 != nil }) {
            turnLbl.text = "It's a Tie!"
        } else {
            // Switch turns
            isXTurn.toggle()
            turnLbl.text = isXTurn ? "Green's Turn" : "Red's Turn"
        }
    }
    
    
    @IBAction func resetBtn(_ sender: UIButton) {
        resetGame()
    }
    
    private func checkWin() -> Bool {
        let winningCombination: [[Int]] = [
            [0, 1, 2], // Top row
            [3, 4, 5], // Middle row
            [6, 7, 8], // Bottom row
            [0, 3, 6], // Left column
            [1, 4, 7], // Middle column
            [2, 5, 8], // Right column
            [0, 4, 8], // Diagonal
            [2, 4, 6]  // Other diagonal
        ]
        
        for combination in winningCombination {
            let indices = combination
            if let first = board[indices[0]]?.image(for: .normal),
               first == board[indices[1]]?.image(for: .normal),
               first == board[indices[2]]?.image(for: .normal) {
                return true
            }
        }
        
        return false
    }
    
    private func disableButtons() {
        tapButtons.forEach { $0.isEnabled = false }
    }
    
    private func resetGame() {
        board = [UIButton?](repeating: nil, count: 9)
        tapButtons.forEach {
            $0.setImage(nil, for: .normal)
            $0.isEnabled = true
        }
        turnLbl.text = "Green's Turn"
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
