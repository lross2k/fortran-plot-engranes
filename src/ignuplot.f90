module ignuplot
	use, intrinsic :: iso_fortran_env, only : wp => real64

	implicit none
	
	contains	
		subroutine ezplot(x,y,arg)
			implicit none
			
			real(wp), allocatable :: x(:), y(:)
			character(len=11) :: arg
			character(len=128) :: outarg
			integer :: i, n_points
			
			outarg = "gnuplot -persist -e ""plot '"//arg//"' with lines"
			
			open(20,file=arg)
	
			write_file: do i=1,size(x)
				write(20,*) x(i),y(i)
			end do write_file
			
			call system(outarg)
			
		end subroutine ezplot

end module ignuplot