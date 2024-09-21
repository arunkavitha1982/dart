import 'dart:io';
import 'dart:math';

void main() {
  Random random = Random();
  int randomNumber = random.nextInt(20);
  int guessesLeft = 10;

  print("Welcome to the guessing game!");
  guessNumber(randomNumber, guessesLeft);
}

void guessNumber(int randomNumber, int guessesLeft) {
  if (guessesLeft == 0) {
    print("You lost the game. The correct number was $randomNumber.");
    return;
  }

  print('Enter your guess: ');
  int guess = int.parse(stdin.readLineSync()!);

  if (guess == randomNumber) {
    print('Congratulations! Your guess is correct.');
    print('Your score is: $guessesLeft');
  } else {
    guessesLeft--;
    if (guess > randomNumber) {
      print("Too high! Try a lower number. Guesses left: $guessesLeft");
    } else {
      print("Too low! Try a higher number. Guesses left: $guessesLeft");
    }
    guessNumber(randomNumber, guessesLeft);
  }
}
