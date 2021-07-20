program plot_engrane
	use ignuplot
	use mechlib
	use, intrinsic :: iso_fortran_env, only : wp => real64
	use pyplot_module, only : pyplot
	
	implicit none
	
	character(len=32) :: inarg
	type(t_gear) :: engrane_a, engrane_b, engrane_c, engrane_d, engrane_e	
	type(t_engine) :: motor
	real(wp) :: lin_acc
	real(wp), allocatable :: w_vel(:), w_dist(:)
	
	type(pyplot)	:: plt
	integer 		:: num_args
	integer			:: i
	integer			:: istat
	
	logical			:: gnu_plotting
	logical			:: py_plotting
	logical			:: no_plotting
	
	num_args = command_argument_count()
	
	py_plotting = .false.
	gnu_plotting = .false.
	no_plotting = .false.
	
	! Checking for special args
	if (num_args .ne. 0) then
		!write(*,*) 'args given:',num_args
		do i=1,num_args
			call getarg(i,inarg)
			!print *,inarg
			plot_type: if (inarg .eq. '-py') then
				py_plotting = .true.
			else if (inarg .eq. '-gnu') then
				gnu_plotting = .true.
			else if (inarg .eq. '-np') then
				no_plotting = .true.
			end if plot_type
		end do
	!else
		!stop
		!print *,'no args'
	end if
	
	! ================= DEFINIENDO SISTEMA ==================
	motor = t_engine(5.0_wp,0.0_wp,0.01_wp)
	motor%ang_vel = 100.0_wp * (4.0_wp + motor%time)
	
	engrane_a = t_gear(40.0_wp)
	engrane_b = t_gear(225.0_wp)
	engrane_c = t_gear(30.0_wp)
	engrane_d = t_gear(300.0_wp)
	engrane_e = t_gear(50.0_wp)
	
	call coax_engine(engrane_a,motor)	
	call ncoax(engrane_a,engrane_b)
	call coax(engrane_b,engrane_c)
	call ncoax(engrane_c,engrane_d)	
	call coax(engrane_d,engrane_e)
	
	allocate(w_vel(size(engrane_e%time)))
	w_vel = tang_vel(engrane_e)
	
	lin_acc = slope(engrane_e%ang_vel(2),engrane_e%ang_vel(1),motor%time(2),motor%time(1))*engrane_e%radius
	
	allocate(w_dist(size(engrane_e%time)))
	w_dist = w_vel(1)*engrane_e%time + lin_acc*(engrane_e%time)**2/2
	
	! ================== FIN DEL SISTEMA ====================
	
	! =================== GENERANDO PLOTS ===================
	if (.not. no_plotting) then
		plot_gnu: if (gnu_plotting) then
			call ezplot(engrane_e%time,engrane_a%ang_vel,"omega_a.dat")
			call ezplot(engrane_e%time,engrane_c%ang_vel,"omega_c.dat")
			call ezplot(engrane_e%time,engrane_e%ang_vel,"omega_e.dat")
			call ezplot(engrane_e%time,w_dist,"w__dist.dat")
		end if plot_gnu
		
		plot_py: if (py_plotting) then
			call plt%initialize(grid=.true.,xlabel='tiempo (s)',ylabel='velocidad angular (rad/s)',title='Omega A')
			call plt%add_plot(engrane_e%time(2:),engrane_a%ang_vel(2:),label='$y_t$',linestyle='b-o',markersize=5,linewidth=2,istat=istat)
			call plt%savefig('omega_a.png',pyfile='omega_a.py',istat=istat)
			
			call plt%initialize(grid=.true.,xlabel='tiempo (s)',ylabel='velocidad angular (rad/s)',title='Omega C')
			call plt%add_plot(engrane_e%time(2:),engrane_c%ang_vel(2:),label='$y_t$',linestyle='b-o',markersize=5,linewidth=2,istat=istat)
			call plt%savefig('omega_c.png',pyfile='omega_c.py',istat=istat)
			
			call plt%initialize(grid=.true.,xlabel='tiempo (s)',ylabel='velocidad angular (rad/s)',title='Omega E')
			call plt%add_plot(engrane_e%time(2:),engrane_e%ang_vel(2:),label='$y_t$',linestyle='b-o',markersize=5,linewidth=2,istat=istat)
			call plt%savefig('omega_e.png',pyfile='omega_e.py',istat=istat)
			
			call plt%initialize(grid=.true.,xlabel='tiempo (s)',ylabel='distancia (mm)',title='Dist W')
			call plt%add_plot(engrane_e%time(2:),w_dist(2:),label='$y_t$',linestyle='b-o',markersize=5,linewidth=2,istat=istat)
			call plt%savefig('w_dist.png',pyfile='w_dist.py',istat=istat)
		end if plot_py
	end if
	! ===================== FIN DE PLOT =====================
	
end program plot_engrane
