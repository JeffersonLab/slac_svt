// -*-Mode: C++;-*-
/*!
* @file
* @brief   Abstract Base Class for defining a procedure
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
#ifndef TOOL_CONCURRENCY_PROCEDURE_HH
#define TOOL_CONCURRENCY_PROCEDURE_HH

namespace tool {
  namespace concurrency {
    class Procedure {
    public:
      virtual ~Procedure() {}

    public:
      virtual void run() = 0;
    };
  } // concurrency
} // tool

#endif // TOOL_CONCURRENCY_PROCEDURE_HH
