import 'dart:io';

class Player {
  String playerName;
  String symbol;
  Player(this.playerName, this.symbol);
}

class Board {
  List<List<String>> grid;

  Board()
      : grid = [
          ['_', '_', '_'],
          ['_', '_', '_'],
          ['_', '_', '_'],
        ];

  void display() {
    for (var row in grid) {
      print(row.join(' '));
    }
  }

  void reset() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        grid[i][j] = '_';
      }
    }
  }

  bool setCoin(int row, int col, String coin) {
    if (row >= 0 && row < 3 && col >= 0 && col < 3) {
      if (grid[row][col] == '_') {
        grid[row][col] = coin;
        return true;
      }
    }
    return false;
  }
}

class winGame {
  bool row(List<List<String>> grid) {
    for (int i = 0; i < 3; i++) {
      if (grid[i][0] != '_' &&
          grid[i][0] == grid[i][1] &&
          grid[i][1] == grid[i][2]) {
        return true;
      }
    }
    return false;
  }

  bool coloum(List<List<String>> grid) {
    for (int i = 0; i < 3; i++) {
      if (grid[0][i] != '_' &&
          grid[0][i] == grid[1][i] &&
          grid[1][i] == grid[2][i]) {
        return true;
      }
    }
    return false;
  }

  bool diagonal(List<List<String>> grid) {
    return (grid[0][0] != '_' &&
            grid[0][0] == grid[1][1] &&
            grid[1][1] == grid[2][2]) ||
        (grid[0][2] != '_' &&
            grid[0][2] == grid[1][1] &&
            grid[1][1] == grid[2][0]);
  }

  bool isWin(List<List<String>> grid) {
    return row(grid) || coloum(grid) || diagonal(grid);
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

class Game {
  Player playerOne;
  Player playerTwo;
  Player currentPlayer;
  Board board = Board();
  winGame winLogic = winGame();

  bool loopend = true;

  Game(this.playerOne, this.playerTwo, this.currentPlayer);

  void playGame() {
    print(
        "${currentPlayer.playerName} (${currentPlayer.symbol}), enter row and column:");
    int row = int.parse(stdin.readLineSync()!) - 1;
    int col = int.parse(stdin.readLineSync()!) - 1;

    if (board.setCoin(row, col, currentPlayer.symbol)) {
      if (winLogic.isWin(board.grid)) {
        board.display();
        print("${currentPlayer.playerName} wins!");
        loopend = false;
      } else if (winLogic.isDraw(board.grid)) {
        board.display();
        print("It's a draw!");
        loopend = false;
      } else {
        currentPlayer = (currentPlayer == playerOne) ? playerTwo : playerOne;
      }
    } else {
      print("Cell is already occupied, try again.");
    }
  }

  void start() {
    while (loopend) {
      board.display();
      playGame();
    }
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
