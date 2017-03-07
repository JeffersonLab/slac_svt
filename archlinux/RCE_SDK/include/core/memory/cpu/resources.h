// -*-Mode: C;-*-
/**
@file
@brief Declaration of the "mem" package atomic resource management functions.
@verbatim
                               Copyright 2015
                                    by
                       The Board of Trustees of the
                    Leland Stanford Junior University.
                           All rights reserved.
@endverbatim
*/
#if !defined(TOOL_MEMORY_ARMCA9_RESOURCES_H)
#define      TOOL_MEMORY_ARMCA9_RESOURCES_H

#if defined(__cplusplus)
extern "C" {
#endif

void* mem_rsAlloc(void* rset);

void  mem_rsFree (void* rset, void* resource);

void*  mem_rsOpen(int numResources, void* base, int stride);

void  mem_rsClose(void** rset);

#if defined(__cplusplus)
}
#endif

#endif
