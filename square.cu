#include <stdio.h>

// nvcc -o square square.cu

__global__ void square(float * d_out, float * d_in) {
    int idx = threadIdx.x;
    float f = d_in[idx];
    // printf("%f --\n",f);
    d_out[idx] = f * f;
}

int main(int argc, char ** argv) {
    const int ARRAY_SIZE = 64;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(float);

    // generate the input array on the host
    float h_in[ARRAY_SIZE];
    for(int i=0; i < ARRAY_SIZE; i++) {
        h_in[i] = float(i);
    }
    float h_out[ARRAY_SIZE];

    //declare gpu memory pointers
    float * d_in;
    float * d_out;

    //allocate GPU memory
    cudaMalloc((void **) &d_in, ARRAY_BYTES);
    cudaMalloc((void **) &d_out, ARRAY_BYTES);

    // transfering the array to gpu
    cudaMemcpy(d_in, h_in, ARRAY_BYTES, cudaMemcpyHostToDevice);

    // Launch the kernel
    square<<<1, ARRAY_SIZE>>>(d_out, d_in);

    // Copy back the result array to the CPU
    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    // Print out the result array
    for(int i=0; i < ARRAY_SIZE; i++) {
        printf("%f", h_out[i]);
        printf(((i%4) != 3) ? "\t" : "\n");
    }

    // free GPU allocation
    cudaFree(d_in);
    cudaFree(d_out);

    return 0;

}