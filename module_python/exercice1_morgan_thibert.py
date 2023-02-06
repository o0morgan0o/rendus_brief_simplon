# Jeu du plus ou moins
# 1- Le programme choisi un nombre au hasard entre 0 et 123, le nombre mystère.
# 2- Il demande à l'utilisateur de le deviner.
# 3- L'utilisateur choisisse un nombre.
# 4- Le programme compare le nombre avec le nombre mystère.
# 5- Le programme dit si le nombre saisi était trop grand ou trop petit.
# 6- Retour à l'étape 2

import random


def main():
    print("Welcome to the game of 'Guess the number'!")

    # choosing a random number between 0 and 123
    answer = int(random.randint(0, 123))
    print("I'm thinking of a number between 0 and 123...")

    # initializing the found boolean
    found = False

    # initializing the number of tries
    tries = 0

    while not found:
        # asking the user to guess the number
        try:
            userInput = int(input("What number to you think it is: "))
        except ValueError:
            print("You must enter a number!!!")
            continue

        if userInput == answer:
            print("Whoaaaa ! You guessed the number!")
            found = True

        elif userInput > answer:
            print("LESS")

        elif userInput < answer:
            print("MORE")

        tries += 1

    print(f"You found the answer, it was {answer}!")
    print(f"You found the number in {tries} tries!")


if __name__ == '__main__':
    main()
