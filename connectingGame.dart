import 'dart:io';

class Board {
  List<List<String>> grid;

  Board() : grid = List.generate(6, (_) => List.filled(7, '_'));

  void display() {
    for (var row in grid) {
      print(row.join(' '));
    }
    print('1 2 3 4 5 6 7');
  }

  void reset() {
    for (var row in grid) {
      row.fillRange(0, row.length, '_');
    }
  }

  bool setCoin(int col, String player) {
    if (col < 0 || col >= 7) {
      print("Invalid column. Choose between 1 and 7.");
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

abstract class WinGame {
  bool isWin(List<List<String>> grid);
  bool row(List<List<String>> grid);
  bool column(List<List<String>> grid);
  bool downLeft(List<List<String>> grid);
  bool downRight(List<List<String>> grid);
  bool isDraw(List<List<String>> grid);
}

class FourConnectionWin extends WinGame {
  @override
  bool isWin(List<List<String>> grid) {
    return row(grid) || column(grid) || downLeft(grid) || downRight(grid);
  }

  @override
  bool row(List<List<String>> grid) {
    for (var row in grid) {
      for (int i = 0; i <= 3; i++) {
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

  @override
  bool column(List<List<String>> grid) {
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row <= 2; row++) {
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

  @override
  bool downLeft(List<List<String>> grid) {
    for (int row = 0; row <= 2; row++) {
      for (int col = 0; col <= 3; col++) {
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

  @override
  bool downRight(List<List<String>> grid) {
    for (int row = 5; row >= 3; row--) {
      for (int col = 0; col <= 3; col++) {
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

  @override
  bool isDraw(List<List<String>> grid) {
    return grid.every((row) => !row.contains('_'));
  }
}

class Game {
  Player playerOne;
  Player playerTwo;
  Player currentPlayer;
  Board board = Board();
  late WinGame winLogic;
  bool isRunning = true;

  Game(this.playerOne, this.playerTwo, this.currentPlayer);

  void playGame() {
    while (isRunning) {
      board.display();
      print("${currentPlayer.playerName} (${currentPlayer.symbol}), enter column (1-7):");

      int col;
      try {
        col = int.parse(stdin.readLineSync()!) - 1;
      } catch (e) {
        print("Invalid input. Please enter a number between 1 and 7.");
        continue;
      }

      if (board.setCoin(col, currentPlayer.symbol)) {
        if (winLogic.isWin(board.grid)) {
          board.display();
          print("${currentPlayer.playerName} (${currentPlayer.symbol}) wins!");
          if (!replay()) break;
        } else if (winLogic.isDraw(board.grid)) {
          board.display();
          print("It's a draw!");
          if (!replay()) break;
        } else {
          currentPlayer = (currentPlayer == playerOne) ? playerTwo : playerOne;
        }
      }
    }
  }

  bool replay() {
    print("Do you want to play again? Enter 1 for Yes:");
    if (stdin.readLineSync() == "1") {
      board.reset();
      return true;
    }
    isRunning = false;
    return false;
  }

  void start() {
    print("Do you want to play Connect 4 or Connect 3? Enter 1 for Connect 4, 2 for Connect 3:");
    int gameChoice;
    try {
      gameChoice = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print("Invalid input. Defaulting to Connect 4.");
      gameChoice = 1;
    }

    winLogic = (gameChoice == 1) ? FourConnectionWin() : FourConnectionWin(); // Default to Connect 4 logic

    playGame();
  }
}

void main() {
  print('Enter Player X Name: ');
  String? playerName1 = stdin.readLineSync();
  Player playerOne = Player(playerName1 ?? "Player X", 'X');

  print('Enter Player O Name: ');
  String? playerName2 = stdin.readLineSync();
  Player playerTwo = Player(playerName2 ?? "Player O", 'O');

  Game game = Game(playerOne, playerTwo, playerOne);
  game.start();
}
