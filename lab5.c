#include <stdio.h>
#include <stdlib.h>

/* sb is always 2 (reflects 0 and 1)
   sk is the number of bits of the exponent
   si is the number of samples */
int sb = 2, si;
extern sk;

/* Time it takes for the kth iteration of the exponentiation algorithm
   on input sample i if the kth exponent bit (keybit) is b.

   Suppose i input samples (to be exponentiated) are known.  Then experiments
   can be run to determine how many nanoseconds it takes to perform
   iteration k of the exponentiation algorithm on sample i.  There are two
   experiments per iteration: the keybit is 0 and the keybit is 1.

   Example use:
     get the time is takes to compute the 17th iteration of y^x mod n
     if the 17th exponent bit is 0 and y is input sample number 45:  
        prompt> int tme = getTime(45, 17, 0);  
*/
int getIterationTime(int i, int k, int b);

int getSpyTime(int i, int k);

int main (int argc, char **argv) {
   int i, k, b;
   if (argc == 1) leave(argv[0]);
   si = atoi(argv[1]);
   if (si <= 0) leave(argv[0]);
   setup();

   /* ------ above this line is fixed, user additions are below ------*/

   printf("number of keybits: %d\nIteration times:\n",sk);
   for (i=0 ; i < si ; i++) {
      printf(" Sample %d, 0 keybits:\n  ", i);
      for (k=0 ; k < sk ; k++) printf("%3d ",getIterationTime(i,k,0));
      printf("\n Sample %d, 1 keybits:\n  ", i);
      for (k=0 ; k < sk ; k++) printf("%3d ",getIterationTime(i,k,1));
      printf("\n");
   }
   printf("\n\nSpy times:\n");
   for (i=0 ; i < si ; i++) {
      printf(" Sample %d, all iterations:\n  ", i);
      for (k=0 ; k < sk ; k++) printf("%4d ",getSpyTime(i,k));
      printf("\n");
   }
}
