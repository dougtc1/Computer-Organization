# Proyecto 2
# Ricardo Churion
# Carnet: 11-10200
# Douglas Torres
# Carnet: 11-11027

# Programa del juego domino que permite el juego entre dos parejas

############ Planificacion de registros ##############
#lectura de archivo
# $t0: Direccion de memoria donde se lee el archivo
# $t1: Direccion de elemento a guardar // reusable
# $t2: Direccion donde se debe detener la lectura // reusable
# $t3: Respaldo de file descriptor // reusable
# $t5: Tiene la ficha que se va a bajar, en el caso de la primera ronda, siempre es la cochina
# $t6: En la inicializacion es auxiliar para distintas operaciones, en el ciclo principal direccion de la ultima ficha agregada al tablero
# $t7: Auxiliar Reusables
# $t8: Direccion de ficha izquierda y direccion de ficha derecha
# $t9: Caja en memoria que almacena en la direccion 0 puntuacion equipo impar, y direccion 4 puntuacion equipo par
				
		.data

cochinaMemoria:	.ascii "(6.6"
cochinaJugador: .asciiz "6.6"
archivo: 	.asciiz "tranca.txt"
nombre:		.asciiz "Introduzca el nombre del jugador "
dospuntos:	.asciiz ": \n"
parentesisA:	.asciiz "("
parentesisC:	.asciiz ")"
salto:		.asciiz "\n"
espacio:	.asciiz " "
mensaje1Cochina: .asciiz "El jugador que tiene la cochina es: "
mensaje2Cochina: .asciiz " tiene la Cochina"
tablero:	.asciiz "El tablero actual es: \n"
turno: 		.asciiz "El turno corresponde a: "
ronda:		.asciiz "Ronda numero: "
mensajePasar:		.asciiz "No puedes jugar ninguna ficha, se pasa tu turno. \n"
corcheteA:	.asciiz "["
corcheteC:	.asciiz "] "
fichasDisponibles: .asciiz "Las fichas disponibles para jugar son: \n"
seleccionFicha: .asciiz "Introduzca el numero que se encuentra a la izquierda de la ficha deseada para jugarla"
victoria: .asciiz " ganaron la partida"
y:		.asciiz " y "
zapatero:	.asciiz " por zapatero"
chancleta:	.asciiz " por chancleta"


		.text

		.globl main
		
		.macro imprimir_t (%texto) #Macro para imprimir un texto
		li $v0, 4
		la $a0, %texto 
		syscall
		.end_macro
		
		.macro imprimir_r (%texto) #Macro para imprimir un texto
		li $v0, 4
		move  $a0, %texto 
		syscall
		.end_macro
		
		
		.macro imprimir_n (%texto) #Macro para imprimir un texto
		li $v0, 4
		lw  $a0, (%texto) 
		syscall
		.end_macro
		
		.macro imprimir_i (%numero) #Macro para imprimir un entero
		li $v0, 1
		move $a0, %numero
		syscall
		.end_macro
	
main: 

	# Reserva de espacio de memoria para guardar los fichas del archivo

	li $v0, 9
	li $a0, 448
	syscall
	
	move $t0, $v0 # Reservo espacio y lo asigno a $t0
	move $t1, $t0
		
	li $v0, 13	#Abro el archivo
	la $a0, archivo
	li $a1, 0	#Modo lectura
	li $a2, 0	
	syscall		#Al hacer el syscall el file descriptor queda en $v0
	
	blt $v0, $zero, fin	#Si hay error termino la ejecuci�n
		
	move $t3, $v0	#Respaldo el file descriptor en $t0
		
	addi $t2, $t1, 224
	
		
leerArchivo:

	li $v0, 14	#Leo el archivo
	move $a0, $t3
	move $a1, $t1
	li $a2, 5
	syscall
	
	blt $v0, $zero, cerrar	#Si hay error cierro el archivo y termino la ejecuci�n 
	
	lw $t4, ($t1)
	
	sw $t4, 224($t1)
	# Imprime fichas conforme se van leyendo del archivo
	
	#imprimir_r($t1)
	#imprimir_t(salto)
	
	addi $t1, $t1, 8
	
	bne $t2, $t1, leerArchivo
	
	

# Inicializacion de Juego
# $t1: Direccion de memoria del jugador 1 // REUSADOS
# $t2: Direccion de memoria del jugador 2 // REUSADOS
# $t3: Direccion de memoria del jugador 3 // REUSADOS
# $t4: Direccion de memoria del jugador 4 // REUSADOS
		
		
InicializacionJuego:

	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	
	# Espacio de memoria del jugador 1
	li $v0, 9
	li $a0, 44
	syscall
	
	move $t1, $v0 # Se asigna la direccion del jugador 1 al registro $t1
	
	move $a0, $t1
	li $a1, 1
	
	jal InicializacionJugadores
	
	move $a0, $t0
	move $a1, $t1
	
	jal Fichas
					
	# Espacio de memoria del jugador 2
	li $v0, 9
	li $a0, 44
	syscall	
	
	move $t2, $v0 # Se asigna la direccion del jugador 1 al registro $t1
	
	move $a0, $t2
	li $a1, 2
	
	jal InicializacionJugadores

	move $a0, $t0	
	addi $a0, $a0, 56
	move $a1, $t2
	
	jal Fichas
	
	# Espacio de memoria del jugador 3
	li $v0, 9
	li $a0, 44
	syscall
	
	move $t3, $v0 # Se asigna la direccion del jugador 1 al registro $t1
	
	move $a0, $t3
	li $a1, 3
	
	jal InicializacionJugadores

	move $a0, $t0	
	addi $a0, $a0, 112
	move $a1, $t3
	
	jal Fichas
	
	# Espacio de memoria del jugador 4
	li $v0, 9
	li $a0, 44
	syscall

	move $t4, $v0 # Se asigna la direccion del jugador 1 al registro $t1
	
	move $a0, $t4
	li $a1, 4
	
	jal InicializacionJugadores
	
	move $a0, $t0	
	addi $a0, $a0, 168
	move $a1, $t4
	
	jal Fichas
	
	move $t7, $zero

	
# Aqui se busca el jugador que tenga la COCHINA, ya que al ser la primera ronda se juega automaticamente dicha pieza

buscarCochina:	
	
	# $t5: Auxiliar que tiene la cochina y se compara con las demas fichas
	# $t6: Auxiliar que tiene la direccion de memoria de cada ficha
	# $t7: Primero, es iterador que dice la cantidad de espacio que me debo mover en memoria
	# $t8: Tiene el numero 8
	# $t9: Tiene el numero 7
	# $a0: Tiene la ficha a comparar con la cochina ($t5)
	
		
	# Como es la primera ronda, se baja la cochina, por eso se carga aqui
	
	lw  $t5, cochinaMemoria
	
	add $t6, $t0, $t7 
	
	lw $a0, ($t6)
	
	addi $t7, $t7, 8
	
	bne $t5, $a0, buscarCochina
	
	addi $t7, $t7, -8
	
	li $t8, 8
	li $t9, 7
	
	# $t7: Dice que jugador tiene la cochina y comienza el juego en la primera ronda // REUSADO
	
	div $t7, $t8
	mflo $t7
	
	div $t7, $t9
	mflo $t7
	
	addi $t7, $t7, 1
	
	# Pasamos como argumento $t7 a la funcion buscarJugador
	
	move $a0, $t7
	
	# Se pasa la direccion del primer jugador para iterar en ella y obtener todos los jugadores

	move $a1, $t1	
	
	jal buscarJugador
	
	# Se reusan $t6, $t8 y $t9
	
	# $t5: Ficha, cochina en este caso
	# $t6: Guardamos el resultado de la funcion, la direccion del jugador encontrado
	# $t7: Numero de jugador que tiene la cochina
	# $t8: Direccion de las fichas del jugador esocgido
	
	move $t6, $v0
	
	addi $t8, $t6, 16

	move $t9, $zero
	
	lw $t5, cochinaJugador
	
	move $a0, $t5
	move $a1, $t6
	move $a2, $t8
	
	jal disminuirContador
	
	imprimir_t(mensaje1Cochina)
	imprimir_r($t6)
	imprimir_t(salto)
	
	#######################################################
	
	# Se reusan los registros $t6, $t8 y $t9
		
	# $t6: Direccion de inicio de espacio del tablero
	# $t8: Direccion de memoria de ficha izquierda en tablero
	# $t9: Direccion de memoria de ficha derecha en tablero
		
	li $v0, 9
	li $a0, 12
	
	syscall
	
	move $t8, $v0 # Se reservan 12 bytes para guardar en los primeros 4 bytes la direccion de la ficha izquierda, del 4 a 8 byte la derecha y en los ultimos 4 bytes la direccion donde comienza el tablero
	
	
	# Se reserva el espacio del tablero, se usa una lista enlazada
	
	li $v0, 9
	li $a0, 200
	
	syscall
	
	move $t6, $v0
	
	sw $t6, 8($t8) # Se asigna la direccion del tablero para guardarla y usarla en cualquier momento
	
	# Aqui se llama a la funcion que coloca la ficha ($t5) en el tablero
	
	move $a0, $t6
	move $a1, $t5
	
	jal bajarPrimeraFicha

	sw $v1, ($t8)
	sw $v1, 4($t8)
			
	# Se reserva una caja de 12 bytes para la puntuacion de cada equipo y el jugador que empezo la ronda
	
	li $v0, 9
	li $a0, 12
	syscall
	
	move $t9, $v0 # Se le asigna esa direccion de memoria a $t9
	
	sw $zero, ($t9)
	sw $zero, 4($t9)
	sw $t7, 8($t9)
	
	# Se reserva una caja de 8 bytes para verificar la suma de puntos en caso de una TRANCA
	
	li $v0, 9
	li $a0, 8
	syscall
	
	move $a3, $v0 # Se le asigna esa direccion de memoria a $a3


cicloPrincipal:


# $t5: Se reusa este registro para que ahora contenga la direccion del jugador que le corresponde jugar
# $s7: PROVICIONAL - Contador de cantidad de turnos pasados 
	
	addi $s7, $s7, -4
	
	beqz $s7, tranca

	addi $s7, $s7, 4
	
	imprimir_t(tablero)
	
	lw $a0, ($t8)
	
	jal imprimirTablero
	
	imprimir_t(salto)
	
	#Cambio de turno
	
	addi $t7, $t7, 1
	
	move $a0,$t7
	
	# Se pasa la direccion del primer jugador para iterar en ella y obtener todos los jugadores

	move $a1, $t1	
	
	jal buscarJugador
	
	move $t7, $v1
	
	move $t5, $v0
	
	imprimir_t(turno)
	imprimir_r($t5)
	imprimir_t(salto)
	
	imprimir_t(fichasDisponibles)
	
	addi $a0, $t5, 16
	move $a1, $t8
	move $v1, $zero
	
	jal verificarFichas
	
	beqz $v0, pasar
	
	move $s7, $zero
	
	move $a0, $v0
	
	jal elegirFicha
	
	move $a0, $v0
	move $a1, $t6
	move $a2, $t8
	
	jal bajarFicha
	
	addi $t6, $t6, 8
	
	move $a0, $v0
	move $a1, $t5
	addi $a2, $t5, 16
	
	jal disminuirContador
	
	beqz  $v0, finDeRonda
	
	b cicloPrincipal


fin:
	li $v0, 10
	syscall
	
	
cerrar:

	li $v0, 16
	move $a0, $t0
	syscall
	
InicializacionJugadores:
	
	# Se "agarran" los elementos de la "pila"
	
	# $s0 es jugador
	# $s1 es numero del jugador
	
	move $s0, $a0
	move $s1, $a1
	
	# Se le pide el nombre al jugador
	
	imprimir_t(nombre)
	imprimir_i($s1)
	imprimir_t(dospuntos)
	
	li $v0, 8
	move $a0, $s0
	li $a1, 10
	syscall
	
	#imprimir_t(salto)

	# Se le asigna el numero del jugador
	
	sw $s1 , 8($s0)
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero

	jr $ra
	
Fichas:

	# $s0 es direccion de las fichas
	# $s1 es jugador
	# $s2 es numero de fichas
	# $s3 es auxiliar para extraer las fichas del lugar de memoria
				
	# Reparticion de fichas para el jugador
	
	move $s0, $a0
	move $s1, $a1
	
	# Se le asigna el contador de fichas al jugador (Todos comienzan el juego con 7 fichas)
	
	li $s2, 7
	sw $s2, 12($s1)

	
	# Reparticion de fichas
	
	# SI HAY CHANCE NO SER PEREZOSO
	
	move $s3, $s0
	
	lb $s4, 1($s3)
	lb $s5, 2($s3)
	lb $s6, 3($s3)
		
	sb $s4, 16($s1)
	sb $s5, 17($s1)
	sb $s6, 18($s1)
		
	lb $s4, 9($s3)
	lb $s5, 10($s3)
	lb $s6, 11($s3)
	
	sb $s4, 20($s1)
	sb $s5, 21($s1)
	sb $s6, 22($s1)
	
		
	lb $s4, 17($s3)
	lb $s5, 18($s3)
	lb $s6, 19($s3)
	
	
	sb $s4, 24($s1)
	sb $s5, 25($s1)
	sb $s6, 26($s1)
		
	lb $s4, 25($s3)
	lb $s5, 26($s3)
	lb $s6, 27($s3)
	
	sb $s4, 28($s1)
	sb $s5, 29($s1)
	sb $s6, 30($s1)
		
	lb $s4, 33($s3)
	lb $s5, 34($s3)
	lb $s6, 35($s3)
	
	sb $s4, 32($s1)
	sb $s5, 33($s1)
	sb $s6, 34($s1)
		
	lb $s4, 41($s3)
	lb $s5, 42($s3)
	lb $s6, 43($s3)
	
	sb $s4, 36($s1)
	sb $s5, 37($s1)
	sb $s6, 38($s1)
		
	lb $s4, 49($s3)
	lb $s5, 50($s3)
	lb $s6, 51($s3)
	
	sb $s4, 40($s1)
	sb $s5, 41($s1)
	sb $s6, 42($s1)
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
	
	
	# Retorno al punto del jal
	
	jr $ra
	
buscarJugador:


	move $s0, $a0
	move $s1, $a1
	
	li $s2, 5
	
	beq $s0, $s2, jugador5
	
	# $s1: Direccion jugador 1
	# $s2: Auxiliar para verificar el numero de jugador
	# $s3: Auxiliar que tiene el numero de jugador
	# $s4: Auxiliar que guarda la direccion de un jugador en especifico
	

	lw $s3, 8($s1)
	la $s4, ($s1)
	beq $s0,$s3, jugadorEncontrado
	
	lw $s3, 52($s1)
	la $s4, 44($s1)
	beq $s0,$s3, jugadorEncontrado
	
	lw $s3, 96($s1)
	la $s4, 88($s1)
	beq $s0,$s3, jugadorEncontrado

	lw $s3, 140($s1)
	la $s4, 132($s1)
	beq $s0,$s3, jugadorEncontrado


jugadorEncontrado:

	# Hay que devolver $s4 porque es la direccion del jugador deseado para jugar y $s0 que es el numero de jugador

	move $v0, $s4
	
	move $v1, $s0
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	
	jr $ra
	
jugador5:

	li $a0,1
	
	b buscarJugador
	
disminuirContador:

	# $s0: Ficha que se bajo
	# $s1: Direccion donde empieza el jugador que acaba de jugar
	# $s2: Direccion de donde comienzan las fichas del jugador
	# $s3: Contador para buscar la ficha en el jugador y volverla cero
	# $s5: Contador de fichas del jugador dado
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	add $s2, $s2, $s3
	
	lw $s4, ($s2)
	
	addi $s3, $s3, 4
	
	bne $s0, $s4, disminuirContador
	
	# Hace cero la posicion de memoria de la ficha del jugador correspondiente
	
	sw $zero, ($s2)
	
	# Disminuimos el contador de fichas del jugador
	
	lw $s5, 12($s1)
	
	addi $s5, $s5, -1
	
	sw $s5, 12($s1)
	
	move $v0, $s5
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	
	jr $ra	
	
	
bajarPrimeraFicha:
	
	# En $a0 tengo la direccion del tablero
	# En $a1 tengo la ficha a colocar
	# En $v0 y $v1 se guarda la direccion de la unica ficha que hay en este momento
	
	move $s0, $a0
	move $s1, $a1
	
	sw $s1, ($s0)
	
	move $v0, $s0
	move $v1, $s0
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	
	jr $ra	
	
imprimirTablero:

	move $s0, $a0
	
	#move $s1, $s0
	
	imprimir_t(parentesisA)
	imprimir_r($s0)
	imprimir_t(parentesisC)
	
	lw $s2, 4($s0)
	
#	move $s0, $s2 #Se mueve al apuntador siguiente.
	
	move $a0, $s2
	
	bnez $s2, imprimirTablero
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero	
	
	jr $ra
	
	
verificarFichas:

	# $s0: Direccion de fichas del jugador
	# $s1: Direccion ficha izquierda del tablero
	# $s2: Direccion ficha derecha del tablero
	# $s3: Contador
	
	addi $s3, $s3, -28
	
	beqz $s3, finVerificacion
	
	addi $s3, $s3, 28
	
	move $s0, $a0
	lw $s1, ($a1) 
	lw $s2, 4($a1)
	
	lb $s1, 0($s1) # Cargo el numero que esta disponible a izquierda
	lb $s2, 2($s2) # Cargo el numero que esta disponible a derecha
	
	add $s0, $s0, $s3
	
	lb $s4, 0($s0)
	lb $s5, 2($s0)
	
	beq $s4, $s1, empilarFicha
	beq $s4, $s2, empilarFicha 
	beq $s5, $s1, empilarFicha
	beq $s5, $s2, empilarFicha	
	
	addi $s3, $s3, 4
	
	b verificarFichas
	
empilarFicha:
	
	addi $sp, $sp, -4
	
	sw $s0, 4($sp)
		
	imprimir_t(corcheteA)
	imprimir_i($v1)
	imprimir_t(corcheteC)
	imprimir_t(parentesisA)
	imprimir_r($s0)
	imprimir_t(parentesisC)
	imprimir_t(espacio)
	
	move $a0, $s0
	
	li $s6, -1
	
	mult $s3, $s6
	
	mflo $s6
	
	add $a0, $a0, $s6
	
	addi $v1, $v1, 1
	
	addi $s3, $s3, 4
		
	b verificarFichas
	
finVerificacion:

	imprimir_t(salto)
	
	move $v0, $v1
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero	
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
	
	jr $ra
		
pasar:
	imprimir_t(mensajePasar)
	
	addi $s7, $s7, 1	
	
	b cicloPrincipal


empilarTodas:
	
	# $s0: Direccion del jugador que juega el primer turno
	
	addi $s0, $a0, 16
	
	li $s3, 28
	
	addi $sp, $sp, -4
	
	lw $s1, ($s0)
	
	sw $s0, 4($sp)
	
	imprimir_t(corcheteA)
	imprimir_i($v1)
	imprimir_t(corcheteC)
	imprimir_t(parentesisA)
	imprimir_r($s0)
	imprimir_t(parentesisC)
	imprimir_t(espacio)
	
	addi $v1, $v1, 1
	
	addi $s2, $s2, 4
	
	move $a0, $s0
	
	beq $s2, $s3, finVerificacion
	

elegirFicha:
	
	# $s0: Numero de elementos empilados
	# $s1: Eleccion de ficha del usuario
	
	move $s0, $a0
	
	imprimir_t(seleccionFicha)
	imprimir_t(salto)
	
	li $v0, 5
	syscall

	move $s1, $v0

	li $s2, -1
	
	mult $s1, $s2
	
	mflo $s2

	add $s3, $s0, $s2

	b desempilarFicha
	
desempilarFicha:

	beq $s5, $s3, finElegirFicha
	lw $s4, 4($sp)
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	
	b desempilarFicha
	
finElegirFicha:

	move $v0, $s4
	
	bne $s0, $s5, vaciarPila
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero	
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	
	jr $ra
	
vaciarPila:

	lw $s4, 4($sp)
	addi $sp, $sp, 4
	addi $s5, $s5, 1
	bne $s5, $s0, vaciarPila

	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero	

	jr $ra
	
bajarFicha:
	
	# $s0: Ficha a bajar
	# $s1: Direccion de ultima ficha agregada al tablero
	# $s2: Direccion de borde (izquierda-derecha) del tablero
	# $s3: Bytes de la ficha para comparar
	# $s4: Numero disponible en izquierda
	# $s5: Se hace copia de registro $t8
	
	move $s0, $a0
	move $s1, $a1
	move $s5, $a2
	
	lw $s6, ($s0)
	
	# HAY QUE REESCRIBIR TODO ESTE CODIGO DE TAL FORMA QUE PRIMERO VERIFICO TODO LO RELACIONADO POR IZQUIERDA
	# Y DESPUES VERIFICO TODO POR LA DERECHA. USAMOS $S2 PARA CARGAR LAS DIRECCIONES, PRIMERO IZQ Y LUEGO DER RESPECTIVAMENTE
	
	
	# Verificacion Izquierda
	
	lw $s2, ($s5)
	
	lb $s3, ($s2)
	
	lb $s4, 2($s0)
	
	beq $s3,$s4, colocarFichaTableroIzq
	
	lb $s4, ($s0)
	
	beq $s3, $s4, voltearFichaIzq
	
	# Verificacion por la Derecha
	
	lw $s2, 4($s5)
	
	lb $s3, 2($s2)
	
	lb $s4, ($s0)
	
	beq $s3, $s4, colocarFichaTableroDer
	
	lb $s4, 2($s0)
	
	beq $s3, $s4, voltearFichaDer


colocarFichaTableroIzq:

	sw $s6, 8($s1)
	sw $s1, 12($s1)

	addi $s3, $s1, 8
	
	sw $s3, ($s5)
	
	move $v0, $s6
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
	
	jr $ra	

colocarFichaTableroDer:

	sw $s6, 8($s1)
	
	addi $s3, $s1, 8
	
	move $v0, $s6
	
	lw $s6, 4($s5)
	
	sw $s3, 4($s6)
	
	sw $s3, 4($s5)
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
					
	jr $ra

voltearFichaIzq:

	# Se reusan $s3 y $s4
	
	lb $s3, ($s0)
	lb $s4, 2($s0)
	
	sb $s4, ($s0)
	sb $s3, 2($s0)
	
	lw $s6, ($s0)
	
	b colocarFichaTableroIzq

voltearFichaDer:

	# Se reusan $s3 y $s4
	
	lb $s3, ($s0)
	lb $s4, 2($s0)
	
	sb $s4, ($s0)
	sb $s3, 2($s0)
	
	lw $s6, ($s0)
	
	b colocarFichaTableroDer
	

tranca:

	# Usamos los $S's temporalmente (agregar a informe)

	# Jugador 1
	
	addi $a0, $t1, 16
	
	jal sumarPuntos

	sw $v0, 4($a3)
	
	# Jugador 2
		
	addi $a0, $t2, 16
		
	jal sumarPuntos

	sw $v0, ($a3)
	
	# Jugador 3

	addi $a0, $t3, 16
		
	jal sumarPuntos

	lw $s0, 4($a3)
	
	add $s0, $s0, $v0
	
	sw $s0, 4($a3)
	
	# Jugador 4
	
	addi $a0, $t4, 16
		
	jal sumarPuntos
	
	lw $s0, ($a3)
	
	add $s0, $s0, $v0
	
	sw $s0, ($a3)
		
	# Se reusa $s0
	
	lw $s0, ($a3)
	lw $s1, 4($a3)
	
	blt $s0, $s1, sumaPuntosEquipoPar
	
	blt $s1, $s0, sumaPuntosEquipoImpar

	b cambioDeRonda
	

sumaPuntosEquipoPar:
	
	lw $s2, 4($t9)
	
	add $s2, $s1, $s2

	sw $s2, 4($t9)
	
	li $s3, 100
	
	bge $s2,$s3,finPartida
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero

	b cambioDeRonda

sumaPuntosEquipoImpar:

	lw $s2, ($t9)
	
	add $s2, $s0, $s2

	sw $s2, ($t9)
	
	li $s3, 100
	
	bge $s2,$s3,finPartida
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	
	b cambioDeRonda
	
sumarPuntos:
	
	# $s0: Direccion de jugador actual

	move $s0, $a0

	add $s0, $s0, $s1
	
	lb $s2, ($s0)
	lb $s3, 2($s0)
	
	addi $s1, $s1, 4
	
	add $s6, $s2, $s3
	
	beqz $s6, sumarPuntos
	
	addi $s2, $s2, -48
	addi $s3, $s3, -48
	
	
	add $s4, $s4, $s2
	
	add $s4, $s4, $s3
	
	li $s5, 28
	
	bne $s1, $s5, sumarPuntos
	
	move $v0, $s4
	
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero	
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero		
	
	jr $ra
	
	
	
finDeRonda:

	li $s0, 2
	
	div $t7, $s0
	
	mflo $s1
	
	beqz $s1, puntosParaPar
	
	b puntosParaImpar

puntosParaPar:

	move $s1, $zero

	addi $a0, $t1, 16
	
	jal sumarPuntos

	move $s1, $v0

	addi $a0, $t3, 16
		
	jal sumarPuntos
	
	move $s2, $v0
	
	add $s1, $s1, $s2
	
	b sumaPuntosEquipoPar


puntosParaImpar:

	move $s1, $zero
	
	addi $a0, $t2, 16
	
	jal sumarPuntos

	move $s1, $v0

	addi $a0, $t4, 16
		
	jal sumarPuntos
	
	move $s2, $v0
	
	add $s2, $s2, $s1
	
	b sumaPuntosEquipoImpar
	
limpiarTablero:
	
	# $s0: Tengo la direccion de la ficha mas a la izquierda del tablero

	move $s0, $a0
		
	sw $zero, ($s0)
	
	lw $s1, 4($s0)
	
	sw $zero, 4($s0)
	
	move $a0, $s1 #Se mueve al apuntador siguiente.
	
	bnez $a0, limpiarTablero
	
	# Se limpian los registros para devolverlos tal como se recibieron
	
	move $s0, $zero
	move $s1, $zero
	
	jr $ra


cambioDeRonda:

	lw $a0, ($t8)
	
	jal limpiarTablero

	move $a0, $t0
	li $a1, 27
	
	jal shuffle
	
	#####################
	
	# Hay que pasarle la posicion de memoria de las fichas y $t1
	
	
	jal Fichas
	
	lw $a0, 8($t9)
	
	addi $a0, $a0, 1
	
	sw $a0, 8($t9)
	
	move $a1, $t1
	
	jal buscarJugador
	
	move $a0, $v0
	
	move $t7, $v1
	
	jal empilarTodas
	
	li $a0, 7
	
	jal elegirFicha
	
	lw $a0, 8($t8)
	
	move $a1, $a0
	
	jal bajarPrimeraFicha
	
	sw $v0, ($t8)
	sw $v1, 4($t8)
	
	b cicloPrincipal	

shuffle:
	
	# $s0: Direccion de memoria donde se encuentran las fichas
	# $s1: Numero 27, que a la vez sirve de contador  
	# $s2: Direccion de copia
	
	
	move $s0, $a0
	move $s1, $a1
	
	addi $s2, $s0, 224
	
	# Numero generado de forma aleatoria
	
	li $v0, 42
	li $a0, 1
	move $a1, $s1
	
	syscall
	
	move $s3, $a0
	
	# Reestablecemos $a0
	
	move $a0, $s0
	
	li $s4, 8
	
	mult $s3, $s4
	
	mflo $s3
	
	add $s3, $s0, $s3
	
	# Reusamos $s3 y $s4
	
	lw $s4, ($s3)
	
	lw $s5, ($s0)
	
	sw $s4, ($s0)
	
	sw $s5, ($s3)
	
	lw $s6, ($s0)
	
	#move $s0, $s6
	
	addi $a0, $a0, 8
	
	addi $a1, $a1, -1
	
	bnez $a1, shuffle
	
	
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
		
	jr $ra

finPartida:

	# $s0: Se coloca la puntuacion del equipo par
	# $s1: Se coloca la puntuacion del equipo impar

	lw $s0, ($t9)
	lw $s1, 4($t9)
	
	bgt $s0, $s2, ganoImpar
	
	b ganoPar

ganoImpar:

	imprimir_r($t1)
	imprimir_t(y)
	imprimir_r($t3)
	imprimir_t(victoria)
	
	beqz $s2, mensajeZapatero
	
	li $s3, 10
	
	ble $s2, $s3, mensajeChancleta
	
	b fin

ganoPar:
	
	imprimir_r($t2)
	imprimir_t(y)
	imprimir_r($t4)
	imprimir_t(victoria)
	
	beqz $s0, mensajeZapatero
	
	li $s3, 10
	
	ble $s0, $s3, mensajeChancleta
	
	b fin
	
mensajeZapatero:

	imprimir_t(zapatero)
	
	b fin
	
mensajeChancleta:

	imprimir_t(chancleta)
	
	b fin
