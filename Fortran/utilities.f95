module utilities
    implicit none
  
    private  ! All entities are now module-private by default
    public public_var, print_matrix  ! Explicitly export public entities
  
    real, parameter :: public_var = 2
    integer :: private_var
  
  contains
      
    ! Print matrix A to screen
    subroutine print_matrix(A)
      real, intent(in) :: A(:,:)  ! An assumed-shape dummy argument
  
      integer :: i
  
      do i = 1, size(A,1)
        print *, A(i,:)
      end do
  
    end subroutine print_matrix

    ! L2 Norm of a vector
    function vector_norm(n,vec) result(norm)
        implicit none
        integer, intent(in) :: n
        real, intent(in) :: vec(n)
        real :: norm
    
        norm = sqrt(sum(vec**2))
    
    end function vector_norm
  
  end module utilities