# Exercice 4: Palindrome Faites un programme qui vérifi si un texte est un palindrome.

import unittest


def check_palindrome(text):
    # we reverse the text
    reversedText = text[::-1]

    # we check if the text is a palindrome
    return text.lower() == reversedText.lower()


def main():
    print("Welcome to the palindrome program!")

    # we ask the user to enter a text
    text = input("Please enter a text: ")
    if (len(text) == 0):
        print("You must enter a text!")
        exit(1)

    isPalindrome = check_palindrome(text)
    if isPalindrome:
        print("The text is a palindrome!")
    else:
        print("The text is not a palindrome!")


if __name__ == '__main__':
    main()


class TestPalindromeFunction(unittest.TestCase):
    def test_correct_palindromes(self):
        self.assertTrue(check_palindrome('radar'))
        self.assertTrue(check_palindrome('Radar'))
        self.assertTrue(check_palindrome('RaDAr'))
        self.assertTrue(check_palindrome('a'))
        self.assertTrue(check_palindrome('1'))
        self.assertTrue(check_palindrome('121'))
        self.assertTrue(check_palindrome('88988'))
        self.assertTrue(check_palindrome('-arara-'))

    def test_incorrect_palindromes(self):
        self.assertFalse(check_palindrome('radars'))
        self.assertFalse(check_palindrome('prout'))
        self.assertFalse(check_palindrome('demoiselle'))
        self.assertFalse(check_palindrome('123'))
        self.assertFalse(check_palindrome('ra dar'))
