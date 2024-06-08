def test_factorial_0():
    assert factorial(0) == 1

def test_factorial_1():
    assert factorial(1) == 1

def test_factorial_positive():
    assert factorial(5) == 120

def test_factorial_large_number():
    assert factorial(12) == 479001600

def test_factorial_negative_number():
    try:
        factorial(-5)
        assert False, "Expected ValueError for negative input"
    except ValueError:
        pass

def test_factorial_non_integer():
    try:
        factorial(4.5)
        assert False, "Expected TypeError for non-integer input"
    except TypeError:
        pass