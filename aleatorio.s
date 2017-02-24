		.data
rango: 	.asciiz "Numero generado aleatoriamente entre 0 y 10: "
aleatorio:	.asciiz "Numero aleatorio: "
salto: 		.asciiz "\n"
		.text
		
		.macro imprimir_t (%texto) #Macro para imprimir un texto
		li $v0, 4
		la $a0, %texto
		syscall
		.end_macro
		
		.macro imprimir_i (%numero) #Macro para imprimir un entero
		li $v0, 1
		move $a0, %numero
		syscall
		.end_macro

#Registros		
#$t0: Contiene el numero aleatorio generado

main:		li $v0, 40	#Configurar semilla del generador, hacer una vez por programa
		li $a0, 0	#Generador 0
		li $a1, 0
		syscall		#Coloco 0 como semilla del generador 0

		li $v0, 41	#Genero un entero aleatorio
		li $a0, 0
		syscall
		move $t0, $a0
		
		imprimir_t(aleatorio)
		imprimir_i($t0)
		imprimir_t(salto)
		
		li $v0, 41	#Genero un entero aleatorio
		li $a0, 0
		syscall
		move $t0, $a0
		
		imprimir_t(aleatorio)
		imprimir_i($t0)
		imprimir_t(salto)
		
		li $v0, 41	#Genero un entero aleatorio
		li $a0, 0
		syscall
		move $t0, $a0
		
		imprimir_t(aleatorio)
		imprimir_i($t0)
		imprimir_t(salto)
		
		li $v0, 42
		li $a0, 0
		li $a1, 10
		syscall
		move $t0, $a0
		
		imprimir_t(rango)
		imprimir_i($t0)
		imprimir_t(salto)

		li $v0, 42
		li $a0, 0
		li $a1, 10
		syscall
		move $t0, $a0
		
		imprimir_t(rango)
		imprimir_i($t0)
		imprimir_t(salto)
		
		li $v0, 42
		li $a0, 0
		li $a1, 10
		syscall
		move $t0, $a0
		
		imprimir_t(rango)
		imprimir_i($t0)
		imprimir_t(salto)	
		
fin:		li $v0, 10
		syscall
