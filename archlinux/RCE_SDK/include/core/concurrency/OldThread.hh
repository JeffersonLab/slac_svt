// -*-Mode: C++;-*-
/*!
* @file
* @brief   Class for creating an execution thread
*
* @author  Anonymous -- REG/DRD - (someone@slac.stanford.edu)
*
* @date    March 29, 2011 -- Created
*
* $Revision: 3096 $
*
* @verbatim
*                               Copyright 2011
*                                     by
*                        The Board of Trustees of the
*                      Leland Stanford Junior University.
*                             All rights reserved.
* @endverbatim
*/
#ifndef TOOL_CONCURRENCY_OLDTHREAD_HH
#define TOOL_CONCURRENCY_OLDTHREAD_HH


#include "concurrency/os/OldThreadImpl.hh"

// JHPFIXME -- I don't like coding with #ifdefs
#ifdef tgt_os_rtems
#include <rtems.h>
#endif

typedef void (*procedure)(void*);

namespace tool {
  namespace concurrency {
    class Procedure;
    class OldThread : public OldThreadImpl {
    public:
      OldThread(const char* name, unsigned priority, unsigned stacksize,
             Procedure& proc);
      OldThread(const char* name, unsigned priority, unsigned stacksize,
             procedure proc, void* data=0);
      ~OldThread();

    public:
      unsigned id() const;

    private:
#ifdef tgt_os_rtems
      friend rtems_task _thread_mainloop_class(rtems_task_argument);
      friend rtems_task _thread_mainloop_func(rtems_task_argument);
#endif
      friend void* _thread_mainloop_class(void*);
      Procedure* _proc;
      procedure  _func;
      void*      _data;
    };
  } // concurrency
} // tool

#endif // TOOL_CONCURRENCY_OLDTHREAD_HH
