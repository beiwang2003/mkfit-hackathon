#include "Config.h"
#include "Debug.h"
#include "propagation_kernels.h"
#include <stdio.h>
#include "gpu_utils.h"


// values from 32 to 512 give good results.
// 32 gives slightly better results (on a K40)
constexpr int BLOCK_SIZE_X = 32;


__device__
void MultHelixProp_fn(const GPlexRegLL& a, const GPlexLS& b, GPlexRegLL& c, const int n)
{
   // C = A * B

   typedef float T;
   /*const idx_t N  = NN;*/

   /*const T *a = A.fArray; ASSUME_ALIGNED(a, 64);*/
   /*const T *b = B.fArray; ASSUME_ALIGNED(b, 64);*/
         /*T *c = C.fArray; ASSUME_ALIGNED(c, 64);*/
  /*float *a = A.ptr;*/
  int aN = 1       ; int an = 0;  // Register array
  int bN = b.stride; int bn = n;  // Global array
  int cN = 1;        int cn = 0;

#if 0
#include "MultHelixProp.ah"
#else
      c[ 0*cN+cn] = a[ 0*aN+an]*b[ 0*bN+bn];
      c[ 0*cN+cn] += a[ 1*aN+an]*b[ 1*bN+bn];
      c[ 0*cN+cn] += a[ 3*aN+an]*b[ 6*bN+bn];
      c[ 0*cN+cn] += a[ 4*aN+an]*b[10*bN+bn];

      c[ 1*cN+cn] = a[ 0*aN+an]*b[ 1*bN+bn];
      c[ 1*cN+cn] += a[ 1*aN+an]*b[ 2*bN+bn];
      c[ 1*cN+cn] += a[ 3*aN+an]*b[ 7*bN+bn];
      c[ 1*cN+cn] += a[ 4*aN+an]*b[11*bN+bn];

      c[ 2*cN+cn] = a[ 0*aN+an]*b[ 3*bN+bn];
      c[ 2*cN+cn] += a[ 1*aN+an]*b[ 4*bN+bn];
      c[ 2*cN+cn] += a[ 3*aN+an]*b[ 8*bN+bn];
      c[ 2*cN+cn] += a[ 4*aN+an]*b[12*bN+bn];
    
      c[ 3*cN+cn] = a[ 0*aN+an]*b[ 6*bN+bn];
      c[ 3*cN+cn] += a[ 1*aN+an]*b[ 7*bN+bn];
      c[ 3*cN+cn] += a[ 3*aN+an]*b[ 9*bN+bn];
      c[ 3*cN+cn] += a[ 4*aN+an]*b[13*bN+bn];
      
      c[ 4*cN+cn] = a[ 0*aN+an]*b[10*bN+bn];
      c[ 4*cN+cn] += a[ 1*aN+an]*b[11*bN+bn];
      c[ 4*cN+cn] += a[ 3*aN+an]*b[13*bN+bn];
      c[ 4*cN+cn] += a[ 4*aN+an]*b[14*bN+bn];

      c[ 5*cN+cn] = a[ 0*aN+an]*b[15*bN+bn];
      c[ 5*cN+cn] += a[ 1*aN+an]*b[16*bN+bn];
      c[ 5*cN+cn] += a[ 3*aN+an]*b[18*bN+bn];
      c[ 5*cN+cn] += a[ 4*aN+an]*b[19*bN+bn];

      c[ 6*cN+cn] = a[ 6*aN+an]*b[ 0*bN+bn];
      c[ 6*cN+cn] += a[ 7*aN+an]*b[ 1*bN+bn];
      c[ 6*cN+cn] += a[ 9*aN+an]*b[ 6*bN+bn];
      c[ 6*cN+cn] += a[10*aN+an]*b[10*bN+bn];
      
      c[ 7*cN+cn] = a[ 6*aN+an]*b[ 1*bN+bn];
      c[ 7*cN+cn] += a[ 7*aN+an]*b[ 2*bN+bn];
      c[ 7*cN+cn] += a[ 9*aN+an]*b[ 7*bN+bn];
      c[ 7*cN+cn] += a[10*aN+an]*b[11*bN+bn];

      c[ 8*cN+cn] = a[ 6*aN+an]*b[ 3*bN+bn];
      c[ 8*cN+cn] += a[ 7*aN+an]*b[ 4*bN+bn];
      c[ 8*cN+cn] += a[ 9*aN+an]*b[ 8*bN+bn];
      c[ 8*cN+cn] += a[10*aN+an]*b[12*bN+bn];

      c[ 9*cN+cn] = a[ 6*aN+an]*b[ 6*bN+bn];
      c[ 9*cN+cn] += a[ 7*aN+an]*b[ 7*bN+bn];
      c[ 9*cN+cn] += a[ 9*aN+an]*b[ 9*bN+bn];
      c[ 9*cN+cn] += a[10*aN+an]*b[13*bN+bn];
      
      c[10*cN+cn] = a[ 6*aN+an]*b[10*bN+bn];
      c[10*cN+cn] += a[ 7*aN+an]*b[11*bN+bn];
      c[10*cN+cn] += a[ 9*aN+an]*b[13*bN+bn];
      c[10*cN+cn] += a[10*aN+an]*b[14*bN+bn];
      
      c[11*cN+cn] = a[ 6*aN+an]*b[15*bN+bn];
      c[11*cN+cn] += a[ 7*aN+an]*b[16*bN+bn];
      c[11*cN+cn] += a[ 9*aN+an]*b[18*bN+bn];
      c[11*cN+cn] += a[10*aN+an]*b[19*bN+bn];
      
      c[12*cN+cn] = a[12*aN+an]*b[ 0*bN+bn];
      c[12*cN+cn] += a[13*aN+an]*b[ 1*bN+bn];
      c[12*cN+cn] += b[ 3*bN+bn];
      c[12*cN+cn] += a[15*aN+an]*b[ 6*bN+bn];
      c[12*cN+cn] += a[16*aN+an]*b[10*bN+bn];
      c[12*cN+cn] += a[17*aN+an]*b[15*bN+bn];
      
      c[13*cN+cn] = a[12*aN+an]*b[ 1*bN+bn];
      c[13*cN+cn] += a[13*aN+an]*b[ 2*bN+bn];
      c[13*cN+cn] += b[ 4*bN+bn];
      c[13*cN+cn] += a[15*aN+an]*b[ 7*bN+bn];
      c[13*cN+cn] += a[16*aN+an]*b[11*bN+bn];
      c[13*cN+cn] += a[17*aN+an]*b[16*bN+bn];
      
      c[14*cN+cn] = a[12*aN+an]*b[ 3*bN+bn];
      c[14*cN+cn] += a[13*aN+an]*b[ 4*bN+bn];
      c[14*cN+cn] += b[ 5*bN+bn];
      c[14*cN+cn] += a[15*aN+an]*b[ 8*bN+bn];
      c[14*cN+cn] += a[16*aN+an]*b[12*bN+bn];
      c[14*cN+cn] += a[17*aN+an]*b[17*bN+bn];
      
      c[15*cN+cn] = a[12*aN+an]*b[ 6*bN+bn];
      c[15*cN+cn] += a[13*aN+an]*b[ 7*bN+bn];
      c[15*cN+cn] += b[ 8*bN+bn];
      c[15*cN+cn] += a[15*aN+an]*b[ 9*bN+bn];
      c[15*cN+cn] += a[16*aN+an]*b[13*bN+bn];
      c[15*cN+cn] += a[17*aN+an]*b[18*bN+bn];
      
      c[16*cN+cn] = a[12*aN+an]*b[10*bN+bn];
      c[16*cN+cn] += a[13*aN+an]*b[11*bN+bn];
      c[16*cN+cn] += b[12*bN+bn];
      c[16*cN+cn] += a[15*aN+an]*b[13*bN+bn];
      c[16*cN+cn] += a[16*aN+an]*b[14*bN+bn];
      c[16*cN+cn] += a[17*aN+an]*b[19*bN+bn];
      
      c[17*cN+cn] = a[12*aN+an]*b[15*bN+bn];
      c[17*cN+cn] += a[13*aN+an]*b[16*bN+bn];
      c[17*cN+cn] += b[17*bN+bn];
      c[17*cN+cn] += a[15*aN+an]*b[18*bN+bn];
      c[17*cN+cn] += a[16*aN+an]*b[19*bN+bn];
      c[17*cN+cn] += a[17*aN+an]*b[20*bN+bn];
      
      c[18*cN+cn] = a[18*aN+an]*b[ 0*bN+bn];
      c[18*cN+cn] += a[19*aN+an]*b[ 1*bN+bn];
      c[18*cN+cn] += a[21*aN+an]*b[ 6*bN+bn];
      c[18*cN+cn] += a[22*aN+an]*b[10*bN+bn];
      
      c[19*cN+cn] = a[18*aN+an]*b[ 1*bN+bn];
      c[19*cN+cn] += a[19*aN+an]*b[ 2*bN+bn];
      c[19*cN+cn] += a[21*aN+an]*b[ 7*bN+bn];
      c[19*cN+cn] += a[22*aN+an]*b[11*bN+bn];
      
      c[20*cN+cn] = a[18*aN+an]*b[ 3*bN+bn];
      c[20*cN+cn] += a[19*aN+an]*b[ 4*bN+bn];
      c[20*cN+cn] += a[21*aN+an]*b[ 8*bN+bn];
      c[20*cN+cn] += a[22*aN+an]*b[12*bN+bn];
      
      c[21*cN+cn] = a[18*aN+an]*b[ 6*bN+bn];
      c[21*cN+cn] += a[19*aN+an]*b[ 7*bN+bn];
      c[21*cN+cn] += a[21*aN+an]*b[ 9*bN+bn];
      c[21*cN+cn] += a[22*aN+an]*b[13*bN+bn];
      
      c[22*cN+cn] = a[18*aN+an]*b[10*bN+bn];
      c[22*cN+cn] += a[19*aN+an]*b[11*bN+bn];
      c[22*cN+cn] += a[21*aN+an]*b[13*bN+bn];
      c[22*cN+cn] += a[22*aN+an]*b[14*bN+bn];
      
      c[23*cN+cn] = a[18*aN+an]*b[15*bN+bn];
      c[23*cN+cn] += a[19*aN+an]*b[16*bN+bn];
      c[23*cN+cn] += a[21*aN+an]*b[18*bN+bn];
      c[23*cN+cn] += a[22*aN+an]*b[19*bN+bn];
      
      c[24*cN+cn] = a[24*aN+an]*b[ 0*bN+bn];
      c[24*cN+cn] += a[25*aN+an]*b[ 1*bN+bn];
      c[24*cN+cn] += a[27*aN+an]*b[ 6*bN+bn];
      c[24*cN+cn] += a[28*aN+an]*b[10*bN+bn];
      
      c[25*cN+cn] = a[24*aN+an]*b[ 1*bN+bn];
      c[25*cN+cn] += a[25*aN+an]*b[ 2*bN+bn];
      c[25*cN+cn] += a[27*aN+an]*b[ 7*bN+bn];
      c[25*cN+cn] += a[28*aN+an]*b[11*bN+bn];
      
      c[26*cN+cn] = a[24*aN+an]*b[ 3*bN+bn];
      c[26*cN+cn] += a[25*aN+an]*b[ 4*bN+bn];
      c[26*cN+cn] += a[27*aN+an]*b[ 8*bN+bn];
      c[26*cN+cn] += a[28*aN+an]*b[12*bN+bn];
      
      c[27*cN+cn] = a[24*aN+an]*b[ 6*bN+bn];
      c[27*cN+cn] += a[25*aN+an]*b[ 7*bN+bn];
      c[27*cN+cn] += a[27*aN+an]*b[ 9*bN+bn];
      c[27*cN+cn] += a[28*aN+an]*b[13*bN+bn];
      
      c[28*cN+cn] = a[24*aN+an]*b[10*bN+bn];
      c[28*cN+cn] += a[25*aN+an]*b[11*bN+bn];
      c[28*cN+cn] += a[27*aN+an]*b[13*bN+bn];
      c[28*cN+cn] += a[28*aN+an]*b[14*bN+bn];
      
      c[29*cN+cn] = a[24*aN+an]*b[15*bN+bn];
      c[29*cN+cn] += a[25*aN+an]*b[16*bN+bn];
      c[29*cN+cn] += a[27*aN+an]*b[18*bN+bn];
      c[29*cN+cn] += a[28*aN+an]*b[19*bN+bn];
      
      c[30*cN+cn] = b[15*bN+bn];
      
      c[31*cN+cn] = b[16*bN+bn];
      
      c[32*cN+cn] = b[17*bN+bn];
      
      c[33*cN+cn] = b[18*bN+bn];
      
      c[34*cN+cn] = b[19*bN+bn];
      
      c[35*cN+cn] = b[20*bN+bn];
#endif
}

__device__
void MultHelixPropTransp_fn(const GPlexRegLL& a, const GPlexRegLL& b, GPlexLS& c, const int n)
{
   // C = B * AT;

   typedef float T;
  int aN = 1       ; int an = 0;  // Register array
  int bN = 1       ; int bn = 0;  // Global array
  int cN = c.stride; int cn = n;

#include "MultHelixPropTransp.ah"
}

// Not passing msRad.stride, as QF == 1 (second dim f msRad)
__device__ void computeMsRad_fn(const GPlexHV& __restrict__ msPar,
    GPlexRegQF &msRad, const int N, const int n) {
  /*int n = threadIdx.x + blockIdx.x * blockDim.x;*/
  if (n < N) {
    msRad(n, 0, 0) = hipo(msPar(n, 0, 0), msPar(n, 1, 0));
  }
}


#include "PropagationMPlex.icc"

__device__ void helixAtRFromIterativeCCS_fn(const __restrict__ GPlexLV& inPar, 
    const __restrict__ GPlexQI& inChg, GPlexLV& outPar_global, const GPlexRegQF& msRad, 
    GPlexRegLL& errorProp,const bool useParamBfield, const int N, const int n)
{

  GPlexRegLV outPar;

  if (n < N) {
    for (int j = 0; j < 5; ++j) {
      outPar[j] = outPar_global(n, j, 0);
    }
    errorProp.SetVal(0);

    helixAtRFromIterativeCCS_impl(inPar, inChg, outPar, msRad, errorProp, n, n+1, -1, useParamBfield);

    // Once computations are done. Get values from registers to global memory.
    for (int j = 0; j < 5; ++j) {
      outPar_global(n, j, 0) = outPar[j];
    }
  }
}


__device__ 
void helixAtRFromIterative_fn(const GPlexLV& inPar,
    const GPlexQI& inChg, GPlexLV& outPar_global, const GPlexRegQF& msRad, 
    GPlexRegLL& errorProp, const int N, const int n) {

  GPlexRegLV outPar;

  if (n < N) {
    for (int j = 0; j < 5; ++j) {
      outPar[j] = outPar_global(n, j, 0);
    }
    errorProp.SetVal(0);

    // FIXME: Pass a sensible value for the last argument (instead of false)
    //        Added to keep compiling ater PR 65
    helixAtRFromIterative_impl(inPar, inChg, outPar, msRad, errorProp, n, n+1, -1, false);

    // Once computations are done. Get values from registers to global memory.
    for (int j = 0; j < 5; ++j) {
      outPar_global(n, j, 0) = outPar[j];
    }
  }
}

/// Similarity ////////////////////////////////////////////////////////////////
__device__ void similarity_fn(GPlexRegLL &a, GPlexLS &b, int N, int n) {

  size_t bN = b.stride;
  
  // Keep most values in registers.
  //float b_reg[LL2];
  GPlexRegLL b_reg;
  // To avoid using too many registers, tmp[] as a limited size and is reused.
  float tmp[6];

  if (n < N) {
    for (int j = 0; j < b.kSize; j++) {
      b_reg[j] = b[n + j*bN];
    }

    tmp[ 0] = a[0]*b_reg[ 0] + a[1]*b_reg[ 1] + a[3]*b_reg[ 6] + a[4]*b_reg[10];
    tmp[ 1] = a[0]*b_reg[ 1] + a[1]*b_reg[ 2] + a[3]*b_reg[ 7] + a[4]*b_reg[11];
    /*tmp[ 2] = a[0]*b_reg[ 3] + a[1]*b_reg[ 4] + a[3]*b_reg[ 8] + a[4]*b_reg[12];*/
    tmp[ 3] = a[0]*b_reg[ 6] + a[1]*b_reg[ 7] + a[3]*b_reg[ 9] + a[4]*b_reg[13];
    tmp[ 4] = a[0]*b_reg[10] + a[1]*b_reg[11] + a[3]*b_reg[13] + a[4]*b_reg[14];
    /*tmp[ 5] = a[0]*b_reg[15] + a[1]*b_reg[16] + a[3]*b_reg[18] + a[4]*b_reg[19];*/

    b[ 0*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1] + tmp[ 3]*a[3] + tmp[ 4]*a[4];


    tmp[ 0] = a[6]*b_reg[ 0] + a[7]*b_reg[ 1] + a[9]*b_reg[ 6] + a[10]*b_reg[10];
    tmp[ 1] = a[6]*b_reg[ 1] + a[7]*b_reg[ 2] + a[9]*b_reg[ 7] + a[10]*b_reg[11];
    /*tmp[ 8] = a[6]*b_reg[ 3] + a[7]*b_reg[ 4] + a[9]*b_reg[ 8] + a[10]*b_reg[12];*/
    tmp[ 3] = a[6]*b_reg[ 6] + a[7]*b_reg[ 7] + a[9]*b_reg[ 9] + a[10]*b_reg[13];
    tmp[ 4] = a[6]*b_reg[10] + a[7]*b_reg[11] + a[9]*b_reg[13] + a[10]*b_reg[14];
    /*tmp[11] = a[6]*b_reg[15] + a[7]*b_reg[16] + a[9]*b_reg[18] + a[10]*b_reg[19];*/

    b[ 1*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1] + tmp[ 3]*a[3] + tmp[ 4]*a[4];
    b[ 2*bN+n] = tmp[ 0]*a[6] + tmp[ 1]*a[7] + tmp[ 3]*a[9] + tmp[ 4]*a[10];


    tmp[ 0] = a[12]*b_reg[ 0] + a[13]*b_reg[ 1] + b_reg[ 3] + a[15]*b_reg[ 6] + a[16]*b_reg[10] + a[17]*b_reg[15];
    tmp[ 1] = a[12]*b_reg[ 1] + a[13]*b_reg[ 2] + b_reg[ 4] + a[15]*b_reg[ 7] + a[16]*b_reg[11] + a[17]*b_reg[16];
    tmp[ 2] = a[12]*b_reg[ 3] + a[13]*b_reg[ 4] + b_reg[ 5] + a[15]*b_reg[ 8] + a[16]*b_reg[12] + a[17]*b_reg[17];
    tmp[ 3] = a[12]*b_reg[ 6] + a[13]*b_reg[ 7] + b_reg[ 8] + a[15]*b_reg[ 9] + a[16]*b_reg[13] + a[17]*b_reg[18];
    tmp[ 4] = a[12]*b_reg[10] + a[13]*b_reg[11] + b_reg[12] + a[15]*b_reg[13] + a[16]*b_reg[14] + a[17]*b_reg[19];
    tmp[ 5] = a[12]*b_reg[15] + a[13]*b_reg[16] + b_reg[17] + a[15]*b_reg[18] + a[16]*b_reg[19] + a[17]*b_reg[20];

    b[ 3*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1]           + tmp[ 3]*a[3] + tmp[ 4]*a[4];
    b[ 4*bN+n] = tmp[ 0]*a[6] + tmp[ 1]*a[7]           + tmp[ 3]*a[9] + tmp[ 4]*a[10];
    b[ 5*bN+n] = tmp[ 0]*a[12] + tmp[ 1]*a[13] + tmp[ 2] + tmp[ 3]*a[15] + tmp[ 4]*a[16] + tmp[ 5]*a[17];


    tmp[ 0] = a[18]*b_reg[ 0] + a[19]*b_reg[ 1] + a[21]*b_reg[ 6] + a[22]*b_reg[10];
    tmp[ 1] = a[18]*b_reg[ 1] + a[19]*b_reg[ 2] + a[21]*b_reg[ 7] + a[22]*b_reg[11];
    tmp[ 2] = a[18]*b_reg[ 3] + a[19]*b_reg[ 4] + a[21]*b_reg[ 8] + a[22]*b_reg[12];
    tmp[ 3] = a[18]*b_reg[ 6] + a[19]*b_reg[ 7] + a[21]*b_reg[ 9] + a[22]*b_reg[13];
    tmp[ 4] = a[18]*b_reg[10] + a[19]*b_reg[11] + a[21]*b_reg[13] + a[22]*b_reg[14];
    tmp[ 5] = a[18]*b_reg[15] + a[19]*b_reg[16] + a[21]*b_reg[18] + a[22]*b_reg[19];

    b[ 6*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1]           + tmp[ 3]*a[3] + tmp[ 4]*a[4];
    b[ 7*bN+n] = tmp[ 0]*a[6] + tmp[ 1]*a[7]           + tmp[ 3]*a[9] + tmp[ 4]*a[10];
    b[ 8*bN+n] = tmp[ 0]*a[12] + tmp[ 1]*a[13] + tmp[ 2] + tmp[ 3]*a[15] + tmp[ 4]*a[16] + tmp[ 5]*a[17];
    b[ 9*bN+n] = tmp[ 0]*a[18] + tmp[ 1]*a[19]           + tmp[ 3]*a[21] + tmp[ 4]*a[22];


    tmp[ 0] = a[24]*b_reg[ 0] + a[25]*b_reg[ 1] + a[27]*b_reg[ 6] + a[28]*b_reg[10];
    tmp[ 1] = a[24]*b_reg[ 1] + a[25]*b_reg[ 2] + a[27]*b_reg[ 7] + a[28]*b_reg[11];
    tmp[ 2] = a[24]*b_reg[ 3] + a[25]*b_reg[ 4] + a[27]*b_reg[ 8] + a[28]*b_reg[12];
    tmp[ 3] = a[24]*b_reg[ 6] + a[25]*b_reg[ 7] + a[27]*b_reg[ 9] + a[28]*b_reg[13];
    tmp[ 4] = a[24]*b_reg[10] + a[25]*b_reg[11] + a[27]*b_reg[13] + a[28]*b_reg[14];
    tmp[ 5] = a[24]*b_reg[15] + a[25]*b_reg[16] + a[27]*b_reg[18] + a[28]*b_reg[19];

    b[10*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1]           + tmp[ 3]*a[3] + tmp[ 4]*a[4];
    b[11*bN+n] = tmp[ 0]*a[6] + tmp[ 1]*a[7]           + tmp[ 3]*a[9] + tmp[ 4]*a[10];
    b[12*bN+n] = tmp[ 0]*a[12] + tmp[ 1]*a[13] + tmp[ 2] + tmp[ 3]*a[15] + tmp[ 4]*a[16] + tmp[ 5]*a[17];
    b[13*bN+n] = tmp[ 0]*a[18] + tmp[ 1]*a[19]           + tmp[ 3]*a[21] + tmp[ 4]*a[22];
    b[14*bN+n] = tmp[ 0]*a[24] + tmp[ 1]*a[25]           + tmp[ 3]*a[27] + tmp[ 4]*a[28];

    tmp[ 0] = b_reg[15];
    tmp[ 1] = b_reg[16];
    tmp[ 2] = b_reg[17];
    tmp[ 3] = b_reg[18];
    tmp[ 4] = b_reg[19];
    tmp[ 5] = b_reg[20];

    // MultHelixPropTransp
    b[15*bN+n] = tmp[ 0]*a[0] + tmp[ 1]*a[1]           + tmp[ 3]*a[3] + tmp[ 4]*a[4];
    b[16*bN+n] = tmp[ 0]*a[6] + tmp[ 1]*a[7]           + tmp[ 3]*a[9] + tmp[ 4]*a[10];
    b[17*bN+n] = tmp[ 0]*a[12] + tmp[ 1]*a[13] + tmp[ 2] + tmp[ 3]*a[15] + tmp[ 4]*a[16] + tmp[ 5]*a[17];
    b[18*bN+n] = tmp[ 0]*a[18] + tmp[ 1]*a[19]           + tmp[ 3]*a[21] + tmp[ 4]*a[22];
    b[19*bN+n] = tmp[ 0]*a[24] + tmp[ 1]*a[25]           + tmp[ 3]*a[27] + tmp[ 4]*a[28];
    b[20*bN+n] = tmp[ 5];
  }
}


// PropagationMPlex.cc:propagateHelixToRMPlex, first version with 6 arguments 
__device__ void propagation_fn(
    GPlexLS &inErr, GPlexLV &inPar, 
    GPlexQI &inChg, GPlexHV &msPar,
    GPlexLS &outErr, GPlexLV &outPar,
    const bool useParamBfield,
    int n, int N) {

  GPlexRegQF msRad_reg;
  // Using registers instead of shared memory is ~ 30% faster.
  GPlexRegLL errorProp_reg;
  // If there is more matrices than max_blocks_x * BLOCK_SIZE_X 
  if (n < N) {
    two_steps_copy<7> (outErr, inErr, n);
    two_steps_copy<6> (outPar, inPar, n);
    for (int i = 0; i < 36; ++i) {
      errorProp_reg[i] = 0.0;
    }
    computeMsRad_fn(msPar, msRad_reg, N, n);
#ifdef CCSCOORD
    helixAtRFromIterativeCCS_fn(inPar, inChg, outPar, msRad_reg, errorProp_reg, useParamBfield, N, n);
#else
    helixAtRFromIterative_fn(inPar, inChg, outPar, msRad_reg, errorProp_reg, N, n);
#endif
    GPlexRegLL temp;
    MultHelixProp_fn      (errorProp_reg, outErr, temp, n);
    MultHelixPropTransp_fn(errorProp_reg, temp,   outErr, n);
  }
}


__global__ void propagation_kernel(
    GPlexLS inErr,
    GPlexHV msPar,
    GPlexLV inPar, GPlexQI inChg,
    GPlexLV outPar,
    GPlexLS outErr, 
    const bool useParamBfield,
    int N)
{
  int grid_width = blockDim.x * gridDim.x;
  int n = threadIdx.x + blockIdx.x * blockDim.x;
  for (int z = 0; z < (N-1)/grid_width  +1; z++) {
    n += z*grid_width;
    propagation_fn(inErr, inPar, inChg, msPar, outErr, outPar, useParamBfield, n, N);
  }
}


void propagation_wrapper(const cudaStream_t& stream,
    GPlexHV& msPar, GPlexLS& inErr,
    GPlexLV& inPar, GPlexQI& inChg,
    GPlexLV& outPar,
    GPlexLS& outErr, 
    const bool useParamBfield,
    const int N) {
  int gridx = std::min((N-1)/BLOCK_SIZE_X + 1,
                       max_blocks_x);
  dim3 grid(gridx, 1, 1);
  dim3 block(BLOCK_SIZE_X, 1, 1);
  propagation_kernel <<<grid, block, 0, stream >>>
    (inErr, msPar, inPar, inChg, outPar, outErr, useParamBfield, N);
}


// PropagationMPlex.cc:propagateHelixToRMPlex, second version with 7 arguments 
// Imposes the radius
__device__ void propagationForBuilding_fn(
    const GPlexLS &inErr, const GPlexLV &inPar,
    const GPlexQI &inChg, const float radius,
    GPlexLS &outErr, GPlexLV &outPar, 
    const int n, const int N) {
  // Using registers instead of shared memory is ~ 30% faster.
  // If there is more matrices than max_blocks_x * BLOCK_SIZE_X 
  if (n < N) {

    two_steps_copy<7> (outErr, inErr, n);
    two_steps_copy<6> (outPar, inPar, n);

    /*for (int i = 0; i < 36; ++i) {*/
      /*errorProp_reg[i] = 0.0;*/
    /*}*/

    GPlexRegQF msRad_reg;
    msRad_reg(n, 0, 0) = radius;

    GPlexRegLL errorProp_reg;
#ifdef CCSCOORD
    bool useParamBfield = false;  // The propagation with radius as an arg do not use this parameter
    helixAtRFromIterativeCCS_fn(inPar, inChg, outPar, msRad_reg, errorProp_reg, useParamBfield, N, n);
#else
    helixAtRFromIterative_fn(inPar, inChg, outPar, msRad_reg, errorProp_reg, N, n);
#endif
    // TODO: port me
    /*if (Config::useCMSGeom) {*/
    /*MPlexQF hitsRl;*/
    /*MPlexQF hitsXi;*/
    /*for (int n = 0; n < NN; ++n) {*/
    /*hitsRl.At(n, 0, 0) = getRlVal(r, outPar.ConstAt(n, 2, 0));*/
    /*hitsXi.At(n, 0, 0) = getXiVal(r, outPar.ConstAt(n, 2, 0));*/
    /*}*/
    /*applyMaterialEffects(hitsRl, hitsXi, outErr, outPar, N_proc);*/
    /*}*/
    /*similarity_fn(errorProp_reg, outErr, N, n);*/

    // GPlex version of:
    // result.errors = ROOT::Math::Similarity(errorProp, outErr);

    //MultHelixProp can be optimized for polar coordinates, see GenMPlexOps.pl
    /*MPlexLL temp;*/
    /*MultHelixProp      (errorProp, outErr, temp);*/
    /*MultHelixPropTransp(errorProp, temp,   outErr);*/
    GPlexRegLL temp;
    MultHelixProp_fn      (errorProp_reg, outErr, temp, n);
    MultHelixPropTransp_fn(errorProp_reg, temp,   outErr, n);

  }
}

__global__ void propagationForBuilding_kernel(
    const GPlexLS inErr, const GPlexLV inPar,
    const GPlexQI inChg, const float radius,
    GPlexLS outErr, GPlexLV outPar, 
    const int N) {
  int grid_width = blockDim.x * gridDim.x;
  int n = threadIdx.x + blockIdx.x * blockDim.x;

  for (int z = 0; z < (N-1)/grid_width  +1; z++) {
    n += z*grid_width;
    propagationForBuilding_fn( inErr, inPar, inChg, radius, outErr, outPar, n, N);
  }
}

void propagationForBuilding_wrapper(const cudaStream_t& stream,
    const GPlexLS& inErr, const GPlexLV& inPar,
    const GPlexQI& inChg, const float radius,
    GPlexLS& outErr, GPlexLV& outPar, 
    const int N) {
  int gridx = std::min((N-1)/BLOCK_SIZE_X + 1,
                       max_blocks_x);
  dim3 grid(gridx, 1, 1);
  dim3 block(BLOCK_SIZE_X, 1, 1);
  propagationForBuilding_kernel<<<grid, block, 0, stream >>>
    (inErr, inPar, inChg, radius, outErr, outPar, N);
}

