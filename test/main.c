#include <setjmp.h>
#include <stdio.h>

static jmp_buf env;

double divide(double a, double b) {
  if (b == 0) {
    longjmp(env, 1);
  }
  return a / b;
}

int main() {
  if (!setjmp(env)) {
    divide(1, 0);
  } else {
    fprintf(stderr, "divide by zero\n");
  }
  return 0;
}
