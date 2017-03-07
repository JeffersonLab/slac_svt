/*
** ++
**  Package:
**  
**
**  Abstract:
**
**  Author:
**      Michael Huffer, SLAC, (415) 926-4269
**
**  Creation Date:
**	000 - June 20 1,1997
**
**  Revision History:
**	None
**
** --
*/

#ifndef TOOL_CONCURRENCY_RTEMS
#define TOOL_CONCURRENCY_RTEMS

#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif

 uint32_t rtems_task_create(uint32_t name, uint32_t priority, uint32_t stack_size, uint32_t mode, uint32_t attributes, uint32_t* _id);
 uint32_t rtems_task_start(uint32_t id, void (*entry_point)(uint32_t), uint32_t argument);
 
#ifdef __cplusplus
 }
#endif

#endif
