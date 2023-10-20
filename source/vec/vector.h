/*
   source/vec/vector.h
   master header file for the libvec library.

   Copyright 2023 Leaf Software Foundation

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/


/* run once */
#pragma once
#ifndef __LEAF_VECTOR_MASTER_HEADER__
#define __LEAF_VECTOR_MASTER_HEADER__

/* include headers */
#include <math.h>
#include <malloc.h>
#include <stdlib.h>


/* custom datatypes */
typedef struct FVector
{
    float  *m;
    size_t count, alloc_len;
} FVector;



/* constants */


/* global variables */


/* external function prototypes */
FVector vec_new_fvector (size_t alloc_len);
void    vec_f_free      (FVector v);
void    vec_f_resize    (FVector *v, size_t new_length);

float vec_f_get (FVector v, unsigned index);
void  vec_f_set (FVector *v, unsigned index, float new_value);


#endif /* end run once */


/* End of File */
