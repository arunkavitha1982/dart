import 'dart:io';

class Board {
  List<List<String>> grid;

  Board()
      : grid = [
          ['_', '_', '_', '_', '_', '_', '_'],
          ['_', '_', '_', '_', '_', '_', '_'],
          ['_', '_', '_', '_', '_', '_', '_'],
          ['_', '_', '_', '_', '_', '_', '_'],
          ['_', '_', '_', '_', '_', '_', '_'],
          ['_', '_', '_', '_', '_', '_', '_'],
        ];

  void display() {
    for (var row in grid) {
      print(row.join(' '));
    }
    print('1 2 3 4 5 6 7');
  }

  void reset() {
    for (var i = 0; i < 6; i++) {
      for (var j = 0; j < 7; j++) {
        grid[i][j] = '_';
      }
    }
  }

  bool setCoin(int col, String player) {
    if (col < 0 || col >= 7) {
      print("Invalid column. Choose between 0 and 6.");
      return false;
    }

    for (int i = 5; i >= 0; i--) {
      if (grid[i][col] == '_') {
        grid[i][col] = player;
        return true;
      }
    }
    print("Column is full. Choose another column.");
    return false;
  }
}

class Player {
  String playerName;
  String symbol;
  Player(this.playerName, this.symbol);
}

class Game {
  Player playerOne;
  Player playerTwo;
  Player currentPlayer;
  Board board = Board();
  winGame winLogic = winGame();
  bool loopEnd = true;
  Game(this.playerOne, this.playerTwo, this.currentPlayer);

  void playGame() {
    board.display();
    print(
        "${currentPlayer.playerName} (${currentPlayer.symbol}), enter column (0-6):");

    int col = int.parse(stdin.readLineSync()!) - 1;
    if (board.setCoin(col, currentPlayer.symbol)) {
      print("successfully added");
    } else {
      print("Invalid input. Please enter a number between 0 and 6.");
    }

    if (winLogic.isWin(board.grid)) {
      board.display();
      print("${currentPlayer.playerName} (${currentPlayer.symbol}) wins!");
      if (replay()) {
        board.reset();
        start();
      } else {
        loopEnd = false;
      }
    } else if (winLogic.isDraw(board.grid)) {
      board.display();
      print("It's a draw!");
    }
    currentPlayer = (currentPlayer == playerOne) ? playerTwo : playerOne;
  }

  bool replay() {
    print("do you want play again, enter 1");
    String? userInput = stdin.readLineSync();
    if (userInput == "1") {
      return true;
    }
    return false;
  }

  void start() {
    print(currentPlayer.symbol);
    print("Game Start!");
    while (loopEnd) {
      playGame();
    }
  }
}

class winGame {
  bool isWin(List<List<String>> grid) {
    return row(grid) || colunm(grid) || downLeft(grid) || downRight(grid);
  }

  bool row(List<List<String>> grid) {
    for (var row in grid) {
      for (int i = 0; i < 4; i++) {
        if (row[i] != '_' &&
            row[i] == row[i + 1] &&
            row[i] == row[i + 2] &&
            row[i] == row[i + 3]) {
          return true;
        }
      }
    }
    return false;
  }

  bool colunm(List<List<String>> grid) {
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 3; row++) {
        if (grid[row][col] != '_' &&
            grid[row][col] == grid[row + 1][col] &&
            grid[row][col] == grid[row + 2][col] &&
            grid[row][col] == grid[row + 3][col]) {
          return true;
        }
      }
    }
    return false;
  }

  bool downLeft(List<List<String>> grid) {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        if (grid[row][col] != '_' &&
            grid[row][col] == grid[row + 1][col + 1] &&
            grid[row][col] == grid[row + 2][col + 2] &&
            grid[row][col] == grid[row + 3][col + 3]) {
          return true;
        }
      }
    }
    return false;
  }

  bool downRight(List<List<String>> grid) {
    for (int row = 5; row > 0; row--) {
      for (int col = 0; col < 4; col++) {
        if (grid[row][col] != '_' &&
            grid[row][col] == grid[row - 1][col + 1] &&
            grid[row][col] == grid[row - 2][col + 2] &&
            grid[row][col] == grid[row - 3][col + 3]) {
          return true;
        }
      }
    }
    return false;
  }

  bool isDraw(List<List<String>> grid) {
    for (var row in grid) {
      if (row.contains('_')) {
        return false;
      }
    }
    return true;
  }
}

void main() {
  print('Enter the X player Name: ');
  String? playerName1 = stdin.readLineSync();
  Player playerOne = Player(playerName1!, 'X');

  print("Enter the O player Name: ");
  String? playerName2 = stdin.readLineSync();
  Player playerTwo = Player(playerName2!, 'O');

  Game game = Game(playerOne, playerTwo, playerOne);
  game.start();
}
