// -*-Mode: C++;-*-
/*!
* @file
* @brief   Class implementing a semaphore
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
#ifndef TOOL_CONCURRENCY_SEMAPHORE_IMPL_HH
#define TOOL_CONCURRENCY_SEMAPHORE_IMPL_HH

#include <pthread.h>
#include <semaphore.h>


namespace tool {
  namespace concurrency {

    namespace linux_ { // Disambiguation for doc generators.
      class SemaphoreImpl {
      public:
        enum State {Red, Green};
        SemaphoreImpl(State initial);
        ~SemaphoreImpl();
        
      protected:
        sem_t _sem;
      };

    } // linux
    using linux_::SemaphoreImpl;

  } // concurrency
} // tool

#endif // TOOL_CONCURRENCY_SEMAPHORE_IMPL_HH
