# Proyecto Ensamblador Z80 "Pong Vertical"
Proyecto <b>"Pong Vertical"</b> de Ensamblador Z80 para <b>Arquitectura de ordenadores</b> 2019/2020.

Trabajo realizado por Sergio Esteban, Jaime Gómez y Marcos Prieto.

# Especificaciones:

• Se trabajará en modo de baja resolución: pantalla de 24x32 caracteres (cada
carácter formado por 8 octetos).

• La pala se situará en la fila 21 y podrá moverse horizontalmente con las teclas ‘I’
y ‘P’ para poder impedir que se caiga la pelota.

• El juego comenzará apareciendo el nombre de este (“Vertical Pong”) en el centro
de la pantalla.

• Los límites del campo son las filas 1 y 20 y las columnas 0 y 31.

• En la parte superior de la pantalla izquierda (línea 0) aparecerá un marcador con
el número de veces que el jugador ha devuelto la bola (rebotes/puntos). En la
parte superior de la pantalla derecha aparecerá un marcador con el número de
vidas restantes.

• Al iniciarse el juego, la pelota aparecerá siempre en la fila 10.

• El juego termina cuando la bola toque la pared inferior de la pantalla 3 veces (hay
3 “vidas”).

• Al finalizar el juego, se mostrará un mensaje de “Game Over”.

• Cuando el usuario pulse cualquier tecla del teclado, comenzará una nueva
partida.

# Puntos a conseguir:
Checkpoints:

•	[X] Inicialización.
•	[X] Aparición inicial del título.
•	[X] Puesta a 0 del contador de impactos.
•	[X] Puesta a a 3 el contador de vidas al iniciar partida.

•	[ ] Rutina de movimiento de la pala.

•	[X] Rutina de movimiento de la pelota. La pelota partirá de una columna aleatoria de la pantalla.
•	[X] Rebotes de la pelota. 
•	[X] Detectar los rebotes en las paredes laterales y superior y cambiar el sentido de la marcha.
•	[X] Detectar rebote en la pala y cambiar el sentido de la marcha.

•	[X] Actualizar el marcador de puntos cada vez que la pelota rebote en la pala.

•	[X] Actualizar el marcador de vidas cada vez que la pelota toca la parte inferior de la pantalla.

•	[X] Terminar la partida cuando se acaban las vidas.
