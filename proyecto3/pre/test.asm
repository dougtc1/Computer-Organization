# Proyecto 3
# Integrantes:
# Ricardo Churion
# Carnet: 11-10200
# Douglas Torres
# Carnet: 11-11027

###########################################################################################################################
# NOTA: Al abrirse el "Keyboard and display MMIO simulator" hay que colocar el "delay length" en el minimo (1 instruction)#
###########################################################################################################################

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
# $s5: Codigo ascii de 0 (cero


        .data
        
mes01: .asciiz "El resultado de la suma es "
salto: .asciiz "\n"
datos: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
n:     .word 20
mes02: .asciiz "Comenzo a ejecutar el programa de prueba\n"
       
       .text   
      
main:

	# Se hace el llamado del syscall 100 para habilitar las interrupciones del teclado y monitor.
	
	li $v0, 100
	syscall
	
	li  	$v0, 4
	la	$a0, mes02
	syscall
ini:	lw	$t0, n		   # Numero de elementos en el arreglo
	la	$t1, datos	   # Direccion de inicio del arreglo
	li 	$v1, 0
	beqz 	$t0, fin
lazo:	lw 	$t2, 0($t1)	   # Carga el i-esimo elemento
	add 	$v1, $v1, $t2	   # Acumula
	addi 	$t0, $t0, -1
	addi 	$t1, $t1, 4
	move  $t3, $v1		   # Numero de veces que se va a ejecutar
	mul   $t3, $t3, 1000	   # el lazo de retardo antes de sumar el
retardo:			   # siguiente elemento del arreglo
	addi	$t3, $t3, -1
	bgtz	$t3, retardo
	bnez	$t0, lazo
fin:	li 	$v0, 4	 	   # Imprime mensaje de resultado
	la	$a0, ,mes01
	syscall
	li 	$v0, 1		   # Imprime el resultado
	move	$a0, $v1
	syscall
	li 	$v0, 4
	la	$a0, salto
	syscall
	b ini			   # Itera indefinidamente
