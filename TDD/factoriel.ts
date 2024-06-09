function factorial(n) {
    if (n === 0 || n === 1) {
      return 1;
    } else {
      return n * factorial(n - 1);
    }
  }
  
  describe('factorial', () => {
    test('factorial of 0 should return 1', () => {
      expect(factorial(0)).toBe(1);
    });
  
    test('factorial of 1 should return 1', () => {
      expect(factorial(1)).toBe(1);
    });
  
    test('factorial of a positive integer should return the correct value', () => {
      expect(factorial(5)).toBe(120);
    });
  
    test('factorial of a negative integer should return 1', () => {
      expect(factorial(-3)).toBe(1);
    });
  
    test('factorial of a large positive integer should not cause overflow', () => {
      expect(factorial(20)).toBe(2432902008176640000);
    });
  
    test('calling factorial with a non-integer should return 1', () => {
      expect(factorial(4.5)).toBe(1);
    });
  });