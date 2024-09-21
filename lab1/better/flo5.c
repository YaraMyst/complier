#include <stdio.h>

int main() {
    float numbers[5]; // Define an array for 5 floating-point numbers
    float sum = 0.0;

    // Prompt the user to input 5 floating-point numbers
    printf("Please enter 5 floating-point numbers:\n");
    for (int i = 0; i < 5; i++) {
        printf("Enter number %d: ", i + 1);
        scanf("%f", &numbers[i]); // Input floating-point number
        sum += numbers[i]; // Accumulate the sum
    }

    // Output the sum of the numbers
    printf("The sum of the 5 floating-point numbers is: %.2f\n", sum);

    return 0;
}

