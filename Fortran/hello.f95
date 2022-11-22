program hello
   ! This is a comment line, it is ignored by the compiler
   use, intrinsic :: iso_fortran_env, only: sp=>real32, dp=>real64
   use utilities , only: print_matrix
   implicit none
   integer, allocatable :: array1(:)
   integer, allocatable :: array2(:,:)
   real, allocatable :: array3(:,:)
   real(sp) :: float32
   real(dp) :: float64
   allocate(array1(10))
   allocate(array2(10,10))
   allocate(array3(10,10))

   call print_matrix(array3)

   deallocate(array1)
   deallocate(array2)
   deallocate(array3)
   print *, 'Hello, World!'


   float32 = 1.0  ! Explicit suffix for literal constants
   float64 = 1.0
   print *, 42
end program hello
