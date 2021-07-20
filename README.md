# Fortran plot engranes
Este script fue creado para resolver un sistema 
mecánico mediante métodos numéricos exactos 
siguiendo el algoritmo de solución estudiado en 
cursos de dinámica vectorial clásica.

# Compilación
Se debe tener primero el archivo `pyplot_module.f90`, 
este no se proporciona pues es del proyecto [pyplot-fortran](https://github.com/jacobwilliams/pyplot-fortran)
, una vez se haya generado este archivo se debe colocar 
en `/src` y se tendrá lo necesario para proceder a compilar.

El proceso de compilación se pensó para usar 
[GFortran](https://gcc.gnu.org/fortran/) y se incluyen 
archivos batch para facilitar la compilación `make.bat` 
y el uso del programa `run_gnuplot.bat`, `run_python.bat` 
es un script muy simple por lo que adaptar las instrucciones 
de GFortran incluídas en los `.bat` no será difícil de 
requerir usarlo desde un sistema UNIX.

# Uso de engranes y motores
En el archivo `main.f90` se encuentra la definición 
de los engranes y el motor.
```Fortran
! ================= DEFINIENDO SISTEMA ==================
	motor = t_engine(5.0_wp,0.0_wp,0.01_wp)
	motor%ang_vel = 100.0_wp * (4.0_wp + motor%time)
	
	engrane_a = t_gear(40.0_wp)
	engrane_b = t_gear(225.0_wp)
	engrane_c = t_gear(30.0_wp)
	. . .
	
	call coax_engine(engrane_a,motor)	
	call ncoax(engrane_a,engrane_b)
	call coax(engrane_b,engrane_c)
	. . .
```
Estos tipos derivados, funciones y subrutinas se 
encuentran definidos en el archivo `mechlib.f90` 
pero la sintaxis no es muy complicada de entender 
sienddo las subrutinas coax y coax_engine para 
poner dos componentes de manera coaxial y los 
ncoax para colocarlos de manera tangencial.

## t_engine(t_final, t_incial, step)
Se encarga de inicializar el tipo derviado t_engine y
generar el array time(:) para simulación transitoria.

De querer resolver otros casos se deberá escribir 
la implimentación en `mechlib.f90` pues originalmente 
no se llegó a necesitar más que esto.

# Graficación
Existen dos maneras de solicitar la generación de un 
plot, sin embargo ninguna es nativa y ambas tienen 
dependencias

## EZPlot
Este módulo fue escrito para comunicar Fortran con 
GNUPLot y se debe llamar a la subrutina de mismo nombre 
ezplot(x_axe,y_axe,"11caractere") y se generará la 
gráfica de tener el programa de graficación correctamente 
instalado.

## Pyplot-Fortran
Utilizando la interfaz creada por [pyplot-fortran](https://github.com/jacobwilliams/pyplot-fortran) 
se grafica con el popular [matplotlib](https://github.com/matplotlib/matplotlib) 
por lo que no se cubrirán las dependencias ni proceso de uso, 
ya que esto es opcional si se quiere aprender a usar este módulo.

## Alternativa ***no realizada***
Si bien nunca se implementó porque no se necesitó y 
porque yo no tengo el conocimiento suficiente para 
hacerlo rápido, también es posible generar gráficas de 
forma nativa sin dependencias al escribir toda la funcionalidad con 
[gtk-fortran](https://github.com/vmagnin/gtk-fortran), 
[fortran-sdl2](https://github.com/interkosmos/fortran-sdl2) o bien 
[F03GL](http://www-stone.ch.cam.ac.uk/pub/f03gl/index.xhtml) pero 
esto requiere de mucho más tiempo y justificar la necesidad.
