const factorial = require('./factorial');

describe('factorial', () => {
  test('returns 1 for factorial of 0', () => {
    expect(factorial(0)).toBe(1);
  });

  test('returns 1 for factorial of 1', () => {
    expect(factorial(1)).toBe(1);
  });

  test('calculates factorial of a positive integer', () => {
    expect(factorial(5)).toBe(120);
    expect(factorial(7)).toBe(5040);
  });

  test('returns Infinity for factorial of a large number', () => {
    expect(factorial(171)).toBe(Infinity);
  });

  test('throws an error for negative input', () => {
    expect(() => factorial(-5)).toThrow('Maximum call stack size exceeded');
    expect(() => factorial(-3)).toThrow("Maximum call stack size exceeded");
  });

  test('throws an error for non-integer input', () => {
    expect(() => factorial(4.5)).toThrow('Maximum call stack size exceeded');
    expect(() => factorial('ABC')).toThrow('Maximum call stack size exceeded')
  });
});