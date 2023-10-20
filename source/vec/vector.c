/*
   source/vec/vector.c
   master source file for the libvec library.

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


#include "vector.h"

/* include headers */
#include <math.h>
#include <malloc.h>
#include <stdlib.h>


/* file static variables */


/* file static function prototypes */


/* function definitions */
FVector
vec_new_fvector (size_t length)
{
    FVector v;

    v->alloc_len = alloc_len;
    v->count     = 0;

    /* dynamically allocate the vector's data section */
    v->m = malloc (alloc_len * sizeof (float));
    if (v->m == NULL)
    {
        /* if malloc fails, throw and error and abort the program */
        fprintf (stderr, "Couldn't realloc; out of memory\n");
        exit (-1);
    }

    return (v);
}


void
vec_f_free (FVector v)
{
    /* free the portion of FVector that was allocated in the constructor */
    free (v.m);
}


void
vec_f_resize (FVector *v, size_t new_length)
{
    /* reallocate to data section the requested size */
    v->m = realloc (v->m, new_length * sizeof (float));
    if (v->m == NULL)
    {
        /* if realloc fails, throw and error and abort the program */
        fprintf (stderr, "Couldn't realloc; out of memory\n");
        exit (-1);
    }

    v->alloc_len = new_length;
}


float
vec_f_get (FVector v, unsigned index)
{
    if (index > v.alloc_len)
    {
        /* if index is greater than the number of allocated numbers, throw an
        error and abort the program */
        fprintf (stderr, "Vector index out of bounds\n");
        exit (-1);
    }

    return (v.m[index])
}


void
vec_f_set (FVector *v, unsigned index, float new_value)
{
    /* if Vector doesn't currently contain the index requested, extend it
    so it does. */
    if (index > v->alloc_len)
    {
        vec_f_resize (v, index);
    }

    /* set the new value at the given index */
    vec->m[index] = new_value;
}


/* End of File */
