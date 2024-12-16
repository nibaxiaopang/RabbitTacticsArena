//
//  GameViewController.swift
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//


import UIKit

class RabbitGameController: UIViewController {

    @IBOutlet weak var gameCollection: UICollectionView!
    @IBOutlet weak var turnLbl: UILabel!

    var board = Array(repeating: "", count: 42)
    var isRedTurn = true

    let red = "red"
    let green = "green"

    override func viewDidLoad() {
        super.viewDidLoad()

        showHowToPlayInstructions()
        gameCollection.dataSource = self
        gameCollection.delegate = self

        // Set the initial turn label
        updateTurnLabel()
    }

    // Helper function to update the turn label
    func updateTurnLabel() {
        let currentPlayer = isRedTurn ? "Red" : "Green"
        turnLbl.text = "\(currentPlayer)'s Turn"
        turnLbl.textColor = isRedTurn ? UIColor.systemRed : UIColor.green
    }

    // Helper function to find the lowest empty cell in a column
    func getLowestEmptyCell(in column: Int) -> Int? {
        for row in (0...5).reversed() {
            let index = row * 7 + column
            if board[index].isEmpty {
                return index
            }
        }
        return nil // Column is full
    }

    // Helper function to check if there's a winner
    func checkWin(at index: Int, for player: String) -> Bool {
        let directions = [
            [1, 0],   // Horizontal
            [0, 1],   // Vertical
            [1, 1],   // Diagonal right
            [1, -1]   // Diagonal left
        ]

        for dir in directions {
            var count = 1
            // Check forward
            var row = index / 7
            var col = index % 7
            for _ in 1...3 {
                row += dir[0]
                col += dir[1]
                let newIndex = row * 7 + col
                if row < 0 || row >= 6 || col < 0 || col >= 7 ||
                   board[newIndex] != player {
                    break
                }
                count += 1
            }

            // Check backward
            row = index / 7
            col = index % 7
            for _ in 1...3 {
                row -= dir[0]
                col -= dir[1]
                let newIndex = row * 7 + col
                if row < 0 || row >= 6 || col < 0 || col >= 7 ||
                   board[newIndex] != player {
                    break
                }
                count += 1
            }

            if count >= 4 {
                return true
            }
        }
        return false
    }

    @IBAction func resetBtn(_ sender: UIButton) {
        // Reset the game board and update the UI
        board = Array(repeating: "", count: 42)
        isRedTurn = true
        gameCollection.reloadData()
        updateTurnLabel()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func showHowToPlayInstructions() {
        let instructions = """
        Welcome to Rabbit Tactics Arena!

        Rules:
        1. The game is played on a grid.
        2. Players take turns dropping pieces (Red or Green) into a column.
        3. The piece will fall to the lowest available cell in the column.
        4. The goal is to align 4 pieces in a row (horizontally, vertically, or diagonally) to win.
        5. If the grid is full and no player has 4 in a row, the game is a draw.

        Good luck and have fun!
        """

        let alert = UIAlertController(
            title: "How to Play",
            message: instructions,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))

        present(alert, animated: true)
    }
}

extension RabbitGameController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollection.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! RabbitGameCollectionViewCell

        // Set cell image based on board state
        if board[indexPath.item] == red {
            cell.imgView.image = UIImage(named: "red")
        } else if board[indexPath.item] == green {
            cell.imgView.image = UIImage(named: "green")
        } else {
            cell.imgView.image = nil
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let column = indexPath.item % 7

        // Find the lowest empty cell in the selected column
        guard let lowestEmptyIndex = getLowestEmptyCell(in: column) else {
            // Column is full
            return
        }

        // Set the piece
        let currentPlayer = isRedTurn ? red : green
        board[lowestEmptyIndex] = currentPlayer

        // Calculate the starting frame within the collection view
        let columnX = collectionView.layoutAttributesForItem(at: indexPath)?.frame.origin.x ?? 0
        let startFrame = CGRect(
            x: columnX,
            y: 0, // Start at the top of the collection view
            width: collectionView.frame.width / 7 - 10,
            height: collectionView.frame.height / 6 - 10
        )

        // Create and animate image view
        let animationImageView = UIImageView(frame: startFrame)
        animationImageView.image = UIImage(named: currentPlayer)
        animationImageView.contentMode = .scaleAspectFit
        collectionView.addSubview(animationImageView) // Add the animation to the collection view

        // Calculate the target frame for the lowest empty cell
        let targetFrame = collectionView.layoutAttributesForItem(at: IndexPath(item: lowestEmptyIndex, section: 0))?.frame ?? .zero

        UIView.animate(withDuration: 0.5, animations: {
            animationImageView.frame = targetFrame
        }, completion: { _ in
            animationImageView.removeFromSuperview()
            self.gameCollection.reloadItems(at: [IndexPath(item: lowestEmptyIndex, section: 0)])

            // Check for win
            if self.checkWin(at: lowestEmptyIndex, for: currentPlayer) {
                let winner = self.isRedTurn ? "Red" : "Green"
                let alert = UIAlertController(title: "Game Over",
                                              message: "\(winner) wins!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "New Game", style: .default) { _ in
                    self.board = Array(repeating: "", count: 42)
                    self.gameCollection.reloadData()
                    self.isRedTurn = true
                    self.updateTurnLabel()
                })
                self.present(alert, animated: true)
            } else {
                // Switch turns
                self.isRedTurn.toggle()
                self.updateTurnLabel()
            }
        })
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 7 - 10, height: collectionView.frame.height / 6 - 10)
    }
}
