import 'dart:math';
import 'dart:io';

class Player {
  String name;
  int guess;
  Player(this.name, this.guess);
}

abstract class Game {
  String name;
  int guess;
  Random random = Random();
  late int randomNumber;

  Game(this.name, this.guess) {
    randomNumber = random.nextInt(20) + 1;
  }

  bool isWin(int guess);
}

class MainGame extends Game {
  int chances = 10;

  MainGame(String name, int guess) : super(name, guess);

  @override
  bool isWin(int guess) {
    if (guess == randomNumber) {
      print("Congratulations! Your guess is correct!");
      return true;
    } else {
      chances--;
      if (chances > 0) {
        if (guess < randomNumber) {
          print("Too low! Try again. Remaining chances: $chances");
        } else {
          print("Too high! Try again. Remaining chances: $chances");
        }
      } else {
        print("You lose the game. The correct number was $randomNumber.");
      }
      return false;
    }
  }
}

void main() {
  print("Enter your name: ");
  String? playerName = stdin.readLineSync();

  Player player = Player(playerName!, 0);
  MainGame game = MainGame(player.name, player.guess);

  print("Welcome, ${player.name}! Let's start the game.");
  print("Guess a number between 1 and 20. You have ${game.chances} chances.");

  while (game.chances > 0) {
    print("Enter your guess: ");
    int guessInput  = int.parse(stdin.readLineSync()!); 
    if (guessInput < 1 || guessInput > 20) {
      print("Invalid input! Please enter a number between 1 and 20.");
      continue;
    }
    player.guess = guessInput;
    print("Your guess: ${player.guess}");
    if (game.isWin(player.guess)) {
      break;
    }
  }
}
