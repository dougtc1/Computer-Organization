# Proyecto 3
# Integrantes:
# Ricardo Churion
# Carnet: 11-10200
# Douglas Torres
# Carnet: 11-11027

# Administracion de registros

# $t4: Segundos derecho
# $t5: Segundo izquierdo
# $t6: Minuto derecho
# $t7: Minuto izquierdo
# $t8: Dos puntos (en ascii)
# $t9: Salto de linea (en ascii)
# $s0: Codigo ascii de t.
# $s1: Codigo ascii de r.
# $s2: Codigo ascii de q.
# $s3: Primero sirve para habilitar teclado y pantalla para que interrumpan, luego sirve de auxiliar para verificaciones
# $s4: Contador del EPC (registro coproc 0 $14)
# $s5: Codigo ascii de 0 (cero).

# NOTA: Al abrirse el "Keyboard and display MMIO simulator" hay que colocar el "delay length" en el minimo (1 instruction) 
# NOTA2: Se borro todo lo indispensable del esqueleto entregado.

# Manejador de interrupciones

	.kdata 0x90000000
	
# S1 y S2 Sirven para guardar valores que se puedan necesitar en el programa principal al salir del manejador

aux1:	.word 0
aux2:	.word 0

	.ktext 0x80000180

	# Se guardan registros que pueden ser importantes en la ejecucion del programa principal
 
 	move $k1 $at
	sw $v0, aux1
	sw $a0, aux2

	# Se extrae causa de interrupcion para ver si es una interrupcion o el syscall 100

	mfc0 $k0 $13		# Registro "Cause"
	srl $a0 $k0 2		# Se corre dos bits y se obtiene el valor
	andi $a0 $a0 0x1f

inicializacion:

	# Se inicializan los registros con los codigos asciis usados en el manejador de interrupciones

	li $s0, 116
	li $s1, 114
	li $s2, 113
	li $s5, 48
	
	li $t8, 58
	li $t9, 10

	# Con el valor en $a0 de la causa se compara para ver si el manejador fue llamado por un syscall o por interrupcion

	beqz $a0, reloj
	b habilitarInterrupciones
	
# Solo se ejecuta esta etiqueta cuando el manejador fue llamado por el syscall 100 y se habilitan los dispositivos
# de teclado y pantalla para que puedan interrumpir el programa principal
	
habilitarInterrupciones:
	
	# Se habilita el teclado
	
	li $s3, 2
	sw $s3, 0xFFFF0000
	
	# Se habilita la pantalla
	
	li $s3, 3
	sw $s3, 0xFFFF0008
	
	# Inicializo todos los registros de "tiempo" con el codigo ascii de (0) cero
	
	move $t4, $s5
	move $t5, $s5			
	move $t6, $s5
	move $t7, $s5
		
	# Se le suma "4" al epc en caso de que el manejador sea llamado por un syscall
	# para evitar que el programa se quede ciclando infinitamente en el manejador
	
	mfc0 $s4, $14
	
	addi $s4, $s4, 4
	
	mtc0 $s4, $14
	
	b salida
	
# Aqui se verifica cual tecla fue presionada, si no es ninguna de las de interes,
# se devuelve la ejecucion al programa principal. En cada caso, se salta a la etiqueta correspondiente.

reloj:
	lb $s3, 0xFFFF0004
	beq $s3, $s0, tick
	beq $s3, $s1, reset
	beq $s3, $s2, quit
	b salida

# En esta etiqueta se le suma un segundo al reloj, en caso de que se llegue a 10 en el registro $t4, se salta
# a la etiqueta segundoDecimal, donde se le suma la unidad al registro $t5 y se hace 0 $t4. En caso contrario
# se salta a pantalla.
	
tick:
	addi $t4, $t4, 1
	
	li $s3, 58	# 58 es el codigo ascii de 10
	
	beq $s3, $t4, segundoDecimal
	
	b pantalla

segundoDecimal:

	move $t4, $s5
	addi $t5, $t5, 1
	
	li $s4, 54	# 54 es el codigo ascii de 6
	
	beq $s4, $t5, minuto
	
	b pantalla

# Si los segundos del reloj llegan a 60, se hacen 0 (cero) y se le suma un minuto al registro $t6, si dicho registro llega
# a 10, se le suma la unidad al registro $t7. 

minuto:

	move $t5, $s5
	
	addi $t6, $t6, 1
	
	li $s3, 58	# 58 es el codigo ascii de 10
	
	beq $s3, $t6, minutoDecimal
	
	b pantalla

minutoDecimal:

	move $t6, $s5
	
	addi $t7, $t7, 1
	
	li $s3, 54	# 54 es el codigo ascii de 6
	
	beq $s3, $t7, reset
	
	b pantalla

# En esta etiqueta se le cola el valor de 0 (cero) en ascii a todos los registros que conforman el reloj

reset:

	move $t4, $s5
	move $t5, $s5
	move $t6, $s5
	move $t7, $s5
	
	b pantalla

# Etiqueta que termina la ejecucion del programa al ser presionada la tecla q

quit:
	li $v0, 10
	syscall

# Etiqueta donde se imprime en pantalla y en "consola" el reloj conforme se vayan realizando las interrupciones

pantalla:

	sw $t7, 0xFFFF000C
	sw $t6, 0xFFFF000C
	sw $t8, 0xFFFF000C
	sw $t5, 0xFFFF000C
	sw $t4, 0xFFFF000C
	sw $t9, 0xFFFF000C
	
	li $v0, 11
	move $a0, $t7
	syscall

	li $v0, 11
	move $a0, $t6
	syscall
	
	li $v0, 11
	move $a0, $t8
	syscall
	
	li $v0, 11
	move $a0, $t5
	syscall
	
	li $v0, 11
	move $a0, $t4
	syscall
	
	li $v0, 11
	move $a0, $t9
	syscall

	b salida

# En esta etiqueta se restauran los valores de los registros que se guardaron al incio del manejador de interrupciones.

salida:

	lw $v0, aux1
	lw $a0, aux2

	move $at $k1
	
	mtc0 $0 $13

	mfc0 $k0 $12
	ori  $k0 0x1
	mtc0 $k0 $12
	
	eret
