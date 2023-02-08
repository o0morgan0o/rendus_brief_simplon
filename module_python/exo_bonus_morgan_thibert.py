import unittest


def fizzbuzz(fizz_number):
    result = ""
    for i in range(1, fizz_number + 1):
        if (i % 3 == 0 and i % 5 == 0):
            result += "FizzBuzz "
        elif i % 5 == 0:
            result += "Buzz "
        elif i % 3 == 0:
            result += "Fizz "
        else:
            result += str(i) + " "
    return result.strip()


if __name__ == '__main__':
    fizzbuzz_row_result = fizzbuzz(35)
    fizzbuzz_column_result = fizzbuzz_row_result.replace(" ", "\n")
    print(fizzbuzz_column_result)


class TestFizzBuzResult(unittest.TestCase):
    def test_correct_values(self):
        self.assertEqual(fizzbuzz(1), "1")
        self.assertEqual(fizzbuzz(2), "1 2")
        self.assertEqual(fizzbuzz(3), "1 2 Fizz")
        self.assertEqual(fizzbuzz(5), "1 2 Fizz 4 Buzz")
        self.assertEqual(fizzbuzz(6), "1 2 Fizz 4 Buzz Fizz")
        self.assertEqual(fizzbuzz(7), "1 2 Fizz 4 Buzz Fizz 7")
        self.assertEqual(fizzbuzz(9), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz")
        self.assertEqual(fizzbuzz(10), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz")
        self.assertEqual(fizzbuzz(14), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14")
        self.assertEqual(fizzbuzz(15), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz")
        self.assertEqual(fizzbuzz(16), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16")
        self.assertEqual(fizzbuzz(18), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz")
        self.assertEqual(fizzbuzz(19), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19")
        self.assertEqual(fizzbuzz(20), "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz")
