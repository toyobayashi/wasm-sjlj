#include <setjmp.h>
#include <stdio.h>

static jmp_buf env;

double divide(double a, double b) {
  if (b == 0) {
    longjmp(env, 2);
  }
  return a / b;
}

int main() {
  int ret = setjmp(env);
  if (ret == 0) {
    divide(1, 0);
  } else if (ret == 2) {
    fprintf(stderr, "divided by zero\n");
    return 0;
  } else {
    return 1;
  }
  return 2;
}
