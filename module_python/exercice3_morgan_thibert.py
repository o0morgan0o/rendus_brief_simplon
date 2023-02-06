# Exercice 3: Immatriculation
#
# Vous devez faire une fonction qui prend en entrée (utilisateur) une chaîne de caractère qui contient l'immatriculation d'un avion
# sous la forme AA-BBBB. La fonction doit remplir une liste avec les parties AA (préfixe). Si l'entrée est invalide,
# comblez par des espaces avant le préfixe.

import unittest


def getFormattedPlate(unformattedPlate):
    # we trim the string and capitalize it
    return unformattedPlate.strip().upper()


def isValidPlate(plateString):
    plateString = getFormattedPlate(plateString)

    # check the length of the string
    if len(plateString) != 7:
        return False

    # first char should be a letter
    if not plateString[0].isalpha():
        return False

    # second char should be a letter
    if not plateString[1].isalpha():
        return False

    # third char should be a dash
    if not plateString[2] == '-':
        return False

    # fourth char should be a number
    if not plateString[3].isnumeric():
        return False

    # fifth char should be a number
    if not plateString[4].isnumeric():
        return False

    # sixth char should be a number
    if not plateString[5].isnumeric():
        return False

    if not plateString[6].isnumeric():
        return False

    return True


def main():
    print("Welcome to the registration number program!")
    plate = input("Please enter a registration number: ")
    plate = getFormattedPlate(plate)

    print(f'checking plate {plate} ...')
    if not isValidPlate(plate):
        print("Invalid registration number! It must be in the form AA-9999")
        return

    print(f'Registration Number {plate} is valid and will be inserted in the database')
    # fake insert in the database


if __name__ == '__main__':
    main()


class TestRegistrationValidation(unittest.TestCase):
    def test_valid_registration(self):
        self.assertTrue(isValidPlate('AA-9999'))
        self.assertTrue(isValidPlate('aX-0000'))
        self.assertTrue(isValidPlate('ab-1234'))
        self.assertTrue(isValidPlate(' ab-1234'))
        self.assertTrue(isValidPlate('ab-1234 '))
        self.assertTrue(isValidPlate(' ab-1234 '))

    def test_check_incorrect_length(self):
        self.assertFalse(isValidPlate('AA-999'))
        self.assertFalse(isValidPlate('AA-99999'))
        self.assertFalse(isValidPlate('AA9999'))

    def test_check_incorrect_prefix_detected(self):
        self.assertFalse(isValidPlate('A-9999'))
        self.assertFalse(isValidPlate('-9999'))
        self.assertFalse(isValidPlate('**-9999'))
        self.assertFalse(isValidPlate('//-9999'))
        self.assertFalse(isValidPlate('89-9999'))
        self.assertFalse(isValidPlate('a7-9999'))

    def test_check_incorrect_suffix_detected(self):
        self.assertFalse(isValidPlate('AA-aaaa'))
        self.assertFalse(isValidPlate('AA-111y'))
        self.assertFalse(isValidPlate('AA-*344'))
        self.assertFalse(isValidPlate('AA-23,0'))
        self.assertFalse(isValidPlate('AA-23 2'))
        self.assertFalse(isValidPlate('AA-232'))

