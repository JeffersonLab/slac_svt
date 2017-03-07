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

#ifndef TOOL_CONCURRENCY_TASK
#define TOOL_CONCURRENCY_TASK

#include <inttypes.h>

namespace tool {
namespace concurrency {

class Task {
public:
  Task(const char* name, uint32_t priority, uint32_t stack_size, uint32_t mode, uint32_t attributes = 0); 
  Task(uint32_t name,    uint32_t priority, uint32_t stack_size, uint32_t mode, uint32_t attributes = 0); 
public:
 virtual ~Task() {}
public:
  void run();
public:  
  uint32_t id() const {return _id;}    
public:  
  virtual void  main_loop() = 0; 
private:
  uint32_t _id; 
};

}}

#endif
