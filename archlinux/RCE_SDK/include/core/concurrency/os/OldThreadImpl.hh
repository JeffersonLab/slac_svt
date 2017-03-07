// -*-Mode: C++;-*-
/*!
* @file
* @brief   Class for creating an execution thread
*
* @author  Anonymous -- REG/DRD - (someone@slac.stanford.edu)
*
* @date    March 29, 2011 -- Created
*
* $Revision: 2961 $
*
* @verbatim
*                               Copyright 2011
*                                     by
*                        The Board of Trustees of the
*                      Leland Stanford Junior University.
*                             All rights reserved.
* @endverbatim
*/
#ifndef TOOL_CONCURRENCY_OLDTHREAD_IMPL_HH
#define TOOL_CONCURRENCY_OLDTHREAD_IMPL_HH

#include <pthread.h>


namespace tool {
  namespace concurrency {
    namespace linux_ { // Disambiguation for doc generators.
      class OldThreadImpl {
      public:
        OldThreadImpl();
        
      protected:
        friend void* _thread_mainloop_class(void*);
        pthread_t _id;
      };
    } // linux
    using linux_::OldThreadImpl;

  } // concurrency
} // tool

#endif // TOOL_CONCURRENCY_THREAD_IMPL_HH
