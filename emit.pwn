/*
 *
 * Pawn AMX Assembly
 * Examples
 *
 *
 * - Use for your 
 *   kinky purposes.
 *
 * Thanks.
 *
 */

#include <a_samp>
#include <YSI_Coding\y_hooks>
stock retn()
{
  #emit SYSREQ.c return // wtf xD
  #emit RETN
  return (1);
}
new some_global;
main()
{
    new some_local;
    #emit ZERO.pri // store zero in the primary register
    #emit STOR.pri some_global // set 'some_global' to the value stored in primary register (zero in this case)
  
    #emit CONST.alt 125
    #emit STOR.S.alt some_local // set 'some_local' to the value stored in the alternate register (125 in this case)
}
new some_global;
hook main()
{
    #emit CONST.pri 10 // put 10 in to the alternate register
    #emit CONST.alt 50 // put 50 in to the alternate register

    #emit CONST.pri some_global // store the address of 'some_global' in the primary register
    #emit CONST.alt some_global // store the address of 'some_global' in the alternate register
}
#include <YSI_Coding\y_hooks>
hook main()
{
    static s_local = 20; // static local variables are stored in the data segment

    new some_local = 10, another_local = 25; // local variables are stored in the stack
    #emit LOAD.S.pri some_local // load the value of 'some_local' into the primary register
    #emit LOAD.S.alt another_local  // load the value of 'another_local' into the alternate register
  
    #emit LOAD.pri s_local // note that static local variables behave like global variables
}
new some_global = 10, another_global = 25;
#include <YSI_Coding\y_hooks>
hook main()
{
    #emit LOAD.pri some_global // load the value of 'some_global' into the primary register
    #emit LOAD.alt another_global  // load the value of 'another_global' into the alternate register
}
new global_arr[10];
#include <YSI_Coding\y_hooks>
hook main ()
{
    #emit CONST.alt global_arr // load the address of 'global_arr' (address of the first element of 'global_arr') into the alternate register
    #emit CONST.pri 2 // set the index of the elment of 'global_arr' that we are interested in
    #emit LIDX // the primary register now has the value stored at 'global_arr[2]`
  
    #emit CONST.alt global_arr // load the address of 'global_arr' (address of the first element) into the alternate register
    #emit CONST.pri 2 // set the index of the elment of 'global_arr' that we are interested in
    #emit IDXADDR // the primary register now has the address of 'global_arr[2]`
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    #emit CONST.pri 4
    #emit CONST.alt 5
  
    #emit SMUL // the primary register now has 20 (SMUL does signed multiplication; UMUL does unsigned multiplication)
    #emit ADD // adds 5 to the 20 (the primary register was storing 20 because of the previous instruction)
    #emit ADD.C 10 // adds 10 to the primary register; now the primary register holds 35
    
    #emit SUB.alt // subtract 35 from 5; the primary register now has -30
    #emit SMUL.C 2 // multiply -30 by 2; this gives -60
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    #emit CONST.pri 5 // .. 0000 0101
    #emit CONST.alt 3 // ... 0000 0011
    #emit AND // primary register will now contain ... 0000 0001
    #emit XOR // primary register will now contain ... 0000 0110
  
    #emit INVERT // take one's complement of the value stored in the primary register
    #emit NEG // take two's complement of the value stored in the primary register (essentially negation)
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    #emit CONST.pri 5
    #emit CONST.alt 8
    #emit EQ // set primary register to 1 if 5 == 8, otherwise zero
    #emit LESS // set primary register to 1 if 0 < 8, otherwise zero
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    new some_local = 25;
    #emit ADDR.alt some_local // computes the address of 'some_local'
    #emit CONST.pri 100
    #emit STOR.I // store 100 in 'some_local'
  
    #emit CONST.pri 100
    #emit STOR.S.pri some_local //a better way to achieve what the above code did
  
    #emit CONST.pri some_local // mysteriously equivalent to CONST.pri -4 (explained later)
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    #emit PUSH.C 100 // pushes the value 100 onto the call stack
    #emit POP.pri // pops a value from the stack and stores the result in the primary register
  
    #emit PUSH.pri // push the value of the primary register
    #emit PUSH.alt // push the value of the alternate register
    #emit POP.pri
    #emit POP.alt // the last 4 instructions effectively swap the contents of the primary register and the alternate register
  
    #emit XCHG // a better way to swap the contents of the primary register and the alternate register
}
#include <YSI_Coding\y_hooks>
hook main ()
{
    new local_array[10];
    #emit ADDR.alt local_array // loads the value stored in 'local_array' which is the address of the array
    #emit CONST.pri 5
    #emit LIDX // effectively stores the value of 'local_array[5]' in the primary register
}
#include <YSI_Coding\y_hooks>
hook main ()
{
     #emit HEAP 16 // make room for four cells (assuming cells are 4 bytes)
     // note that the HEAP instruction had also set the alternate register to the start of our reserved memory
     // ALT = HEA, HEA += 16
   
     #emit CONST.pri 50
     #emit STOR.I // effectively stores the value 50 in the first cell of our reserved area of the heap
    
     #emit HEAP -16 // return the reserved memory back
}
#include <YSI_Coding\y_hooks>
hook main ()
{
     new cod, dat;
     #emit LCTRL 0 // store the value of the COD segment register in the primary register
     #emit STOR.S.pri cod
   
     #emit LCTRL 1 // store the value of the DAT segment register in the primary register
     #emit STOR.S.pri dat
   
     printf("%d %d", cod, dat);
}
f()
{
    print("f() was called.");
}
#include <YSI_Coding\y_hooks>
hook main ()
{
   #emit PUSH.C 0 // number of bytes taken up by arguments (explained later)
   #emit LCTRL 6 // get the value of CIP which is the address of the next instruction (ADD.C in our case)
   #emit ADD.C 28 // compute the address of the instruction to be executed after 'f' (note that each opcode and operand requires a cell)
   #emit PUSH.pri // push the return address so that 'f' knows where to return to (explained later)
   #emit CONST.pri f // store the address of the function 'f' in pri
   #emit SCTRL 6 // set the current instruction pointer to the value stored in the primary register
   
   // the function 'f' executes
   // after the function 'f' returns, the next instruction (NOP in our case) will begin to execute
   
   #emit NOP // instruction that does nothing 
}
#include <YSI_Coding\y_hooks>
hook main()
{  
    #emit JUMP check // jump to the check label

    not_equal:
       printf("1 is not equal to 2");
       return 0;

    equal:
       print("1 is equal to 2");
       return 0;

    check:
       #emit CONST.pri 1
       #emit CONST.alt 2
       #emit JEQ equal // if the value of the primary register is equal to that of the alternate register, then jump to 'equal'
       #emit JUMP not_equal // if we ended up here, it implies that the values of the two registers were not equal; hence, jump to 'not_equal'
}
