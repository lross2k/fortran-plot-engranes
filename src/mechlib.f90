module mechlib
	use, intrinsic :: iso_fortran_env, only : wp => real64

	implicit none
	
	private
	public t_gear, t_engine, coax_engine, coax, ncoax, tang_vel, slope
	
	! Derived types created
	type :: t_kinematic
		real(wp), allocatable :: ang_vel(:)
		real(wp), allocatable :: ang_acc(:)
		real(wp), allocatable :: time(:)
	end type
	
	type, extends(t_kinematic) :: t_gear
		real(wp)	:: radius
		integer :: teeth
	end type
	
	type, extends(t_kinematic) :: t_engine
		real(wp)	:: time_start, time_stop, time_presicion
	end type

	! Procedure interfaces
    interface t_gear
		module procedure t_gear_init
    end interface
	
	interface t_engine
		module procedure t_engine_init
    end interface
	
	interface ncoax
		module procedure no_coax_gear
	end interface
	
	interface coax
		module procedure coax_gear
	end interface

	! Functions and subroutines
	contains
		function vector(i,j,k) result(vec)
			implicit none
			
			real(wp), intent(in) :: i,j,k
			real(wp), dimension(3) :: vec
			
			vec(:) = (/i,j,k/)
			
		end function vector
		
		function t_gear_init(radius, teeth) result(gear)
			implicit none
			
			integer, optional :: teeth
			real(wp) :: radius
			type(t_gear) :: gear
			
			gear%radius = radius
			
			if (present(teeth)) then
				gear%teeth = teeth
			else
				gear%teeth = 0
			end if
			
		end function t_gear_init

		function t_engine_init(t_final, t_initial, t_step) result(engine)
			implicit none
			
			real(wp), optional, intent(in) :: t_initial, t_step
			real(wp), intent(in) :: t_final
			real(wp), allocatable :: period(:)
			integer :: n_count, i
			real(wp) :: adder
			type(t_engine) :: engine
			
			engine%time_stop = t_final
			
			if (present(t_initial)) then
				engine%time_start = t_initial
			else
				engine%time_start = 0.0
			end if
			
			if (present(t_step)) then
				engine%time_presicion = t_step
			else
				engine%time_presicion = 0.1
			end if
			
			n_count = (engine%time_stop - engine%time_start)/engine%time_presicion + 1
			allocate(period(n_count))
			i = 1
			do while (i .le. n_count)
				period(i) = adder
				adder = adder + engine%time_presicion
				i = i + 1
			end do
			
			engine%time = period
			
		end function t_engine_init
		
		function tang_vel(gear) result(vel)
			implicit none
			
			type(t_gear), intent(in) :: gear
			real(wp), allocatable :: vel(:)
			
			allocate(vel(size(gear%time)))
			vel(:) = gear%radius*gear%ang_vel
			
		end function tang_vel
		
		! velocity distance -t
		! distance time -v
		! time velocity -d
		function rel_vdt(num1, num2, arg) result(res)
			implicit none
			
			character(len=10), intent(in) :: arg
			real(wp), intent(in) :: num1, num2
			real(wp) :: res
			
			if (arg .eq. '-d') then
				res = num1 * num2
			else if (arg .eq. '-v') then
				res = num1/num2
			else if (arg .eq. '-t') then
				res = num2/num1
			else
				res = 0.0
			end if
			
		end function rel_vdt
		
		function slope(y2, y1, x2, x1) result(slp)
			implicit none
			
			real(wp), intent(in) :: y2, y1, x2, x1
			real(wp) :: slp
			
			slp = (y2 - y1)/(x2 - x1)
			
		end function slope
		
		! engine moves the gear
		subroutine coax_engine(gear, engine)
			implicit none
			
			type(t_gear) :: gear
			type(t_engine), intent(in) :: engine
			
			gear%time = engine%time
			gear%ang_vel = engine%ang_vel
			
		end subroutine coax_engine
		
		! gear_a moves gear_b
		subroutine coax_gear(geara, gearb)
			implicit none
			
			type(t_gear) :: gearb
			type(t_gear), intent(in) :: geara
			
			gearb%time = geara%time
			gearb%ang_vel = geara%ang_vel
			! gotta implement accel
			
		end subroutine coax_gear
		
		subroutine no_coax_gear(geara, gearb)
			implicit none
			
			type(t_gear) :: gearb
			type(t_gear), intent(in) :: geara
			
			gearb%time = geara%time
			gearb%ang_vel = geara%ang_vel*(geara%radius/gearb%radius)
			
		end subroutine no_coax_gear
		
		function create_kinematic(ang_vel, ang_acc, lin_acc, lin_vel) result(k_body)
			implicit none
			
			real(wp), optional :: ang_vel, ang_acc, lin_vel, lin_acc
			type(t_kinematic) :: k_body
			
			if (present(ang_acc)) then
				k_body%ang_acc = ang_acc
			else
				k_body%ang_acc = 0
			end if
			
			if (present(ang_vel)) then
				k_body%ang_vel = ang_vel
			else
				k_body%ang_vel = 0
			end if
			
		end function create_kinematic
		
		function cross_vec(vec_a,vec_b) result(vec_c)
			implicit none
			
			real(wp), dimension(3) ,intent(in) :: vec_a,vec_b
			real(wp), dimension(3) :: vec_c
			
			vec_c(1) = vec_a(2)*vec_b(3)-vec_a(3)*vec_b(2)
			vec_c(2) = vec_a(3)*vec_b(1)-vec_a(1)*vec_b(3)
			vec_c(3) = vec_a(1)*vec_b(2)-vec_a(2)*vec_b(1)
			
		end function cross_vec
		
		function torque(radius, force) result(torr)
			implicit none
			
			real(wp), dimension(3) ,intent(in) :: radius,force
			real(wp), dimension(3) :: torr

			torr = cross_vec(radius,force)
			
		end function torque
	
end module mechlib
