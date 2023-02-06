# exercise 2
# On demande 2 nombres à l'utilisateur (X et Y), puis on affiche des '@' pour réaliser une grille de X colonnes par Y lignes.
# Le nombre de colonnes doit toujours être supérieur au nombre de lignes.
# Si X = 6 et Y =4
# @@@@@@
# @@@@@@
# @@@@@@
# @@@@@@

import argparse


def validateArguments(width, height):
    # check that the width is an int
    try:
        width = int(width)
    except ValueError:
        # it should never except because the parser should have already checked that
        print("Width must be a number!!!")
        exit(1)

    # check that the height is an int
    try:
        height = int(height)
    except ValueError:
        # it should never except because the parser should have already checked that
        print("Height must be a number!!!")
        exit(1)

    if width <= 0:
        print("Width must be greater than 0!")
        exit(1)

    if height <= 0:
        print("Height must be greater than 0!")
        exit(1)

    if width < height:
        print("The width must be greater than the height!")
        exit(1)


parser = argparse.ArgumentParser(
    description='This program will print a grid of @',
)

parser.add_argument('-X', action="store", type=int, default=10, required=True)
parser.add_argument('-Y', action="store", type=int, default=4, required=True)
args = parser.parse_args()

# we validate arguments
validateArguments(args.X, args.Y)


def main():
    print('Welcome to the grid printer program!')
    width = int(args.X)
    height = int(args.Y)

    # for each line we will print the width number of '@'
    for i in range(height):
        print(width * '@')


if __name__ == '__main__':
    main()
