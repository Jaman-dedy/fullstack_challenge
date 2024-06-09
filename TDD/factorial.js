//Write unit tests with at least 6 test case scenarios that would be satisfied by the above function. 

function factorial(n) {
    if (n === 0 || n === 1) {
      return 1;
    } else {
      return n * factorial(n - 1);
    }
  }

  module.exports = factorial;