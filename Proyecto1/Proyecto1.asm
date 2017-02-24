# Proyecto 1
# Ricardo Churion
# Carnet: 11-10200
# Douglas Torres
# Carnet: 11-11027

# Programa que realiza un arbol a partir de un arreglo dado 
# e imprime sus elementos en Inorden y Postorden

# Planificacion de los Registros
#   ###############################
# $t0: Numero de elementos del arbol
# $t1: Direccion de RAIZ
# $t2: Temporal de elemento del arreglo a agregar al arbol
# $t3: Temporal elemento de ES_HOJA
# $t4: Contador del ciclo.
# $t5: Direccion de elemento a enlazar
# $t6: Valor auxiliar
# $t7: Direccion de caja padre
# $t8 auxilar numero
# $t9 auxiliar caja
# $s0: Direccion del arreglo VALORES
	
	.data
	
	VALORES: .word 42, 35, 7, 8, 38, 70, 45, 101, 300
	ES_HOJA: .byte 0, 0, 0, 1, 1, 0, 1, 0, 1
	TAMANO: .word 9	
	ESPACIO: .asciiz " "
	H: .asciiz "h"
	SALTO: .asciiz "\n"
	INORDEN: .asciiz "IN-ORDEN"
	POSTORDEN: .asciiz "POS-ORDEN"
	PUNTOS: .asciiz ":"
	
	.text
	
# Etiqueta principal del programa

main:
	# Inicializacion de valores
	
	li $v0, 9
	li $a0, 12
	syscall
	
	move $t1, $v0
	
	la $s0, VALORES
	la $s1, ES_HOJA
	lw $t0, TAMANO
	
	li $t4, 1
	
	move $s4, $zero
	
	move $s2, $zero
	
	# Inicializacion de RAIZ
	
	lw $t2, ($s0)
	sw $t2, ($t1)
	sw $zero, 4($t1)
	sw $zero, 8($t1)
	move $t7, $t1
	move $s2, $zero
	
	# Se imprime en pantalla el formato
	
	la $a0, INORDEN
	li $v0, 4
	
	syscall
	
	la $a0, PUNTOS
	li $v0, 4
	
	syscall
	
	la $a0, SALTO
	li $v0, 4
	
	syscall

# Ciclo principal del programa donde se crea el arbol

ciclo1:
	
	lw $t6, ($t1)
	move $t7, $t1

	beq $t4, $t0, imprimir
	addi $t4, $t4, 1
	
	addi $s0, $s0, 4
	
	lw $t2, ($s0)
	
	li $v0, 9
	li $a0, 12
	syscall
	
	move $t5,$v0
	
	sw $t2, ($t5)
	sw $zero, 4($t5)
	sw $zero, 8($t5)
	
	b comparar

# Etiqueta donde se compara y decide a que hijo agregar el siguiente elemento

comparar: 
	
	blt $t2, $t6, hijo_izq
	
	bgt $t2, $t6, hijo_der
	
# Etiqueta donde se agrega el elemento en el hijo izquierdo
	
hijo_izq:
	li $t8, 4
	lw $t6, 4($t7)
	bnez $t6, actualizar
	sw $t5, 4($t7)
	b ciclo1
	
# Etiqueta donde se agrega el elemento en el hijo derecho
	
hijo_der:
	li $t8, 8
	lw $t6, 8($t7)
	bnez $t6, actualizar
	sw $t5, 8($t7)
	b ciclo1
	
# Etiqueta donde se recorre el arbol dependiendo de donde debo agregar el elemento
	
actualizar:
	
	add $t9, $t7, $t8
	lw $t7, ($t9)
	move $t7, $t6
	lw $t6 , ($t7)
	b comparar


# A partir de aqui se reusan los registros $t4, $t5, $t6, $t7, $t8, $t9 Y $s1 de la siguiente forma:
# $t4: INORDEN y POSTORDEN: Contador de ciclos.
# $t5: INORDEN y POSTORDEN: Direccion de caja actual
# $t6; INORDEN y POSTORDEN: Registro auxiliar que sirve para verificar el valor del hijo
# $t7: INORDEN: Direccion de caja del padre
# $t8: INORDEN: Padre auxiliar 2. En POSTORDEN: Variable de verificacion
# $t9: INORDEN: Direccion auxiliar que guarda al padre del elemento a imprimir. En POSTORDEN: Valor que dice el recorrido en postorden del subarbol derecho de la raiz
# $s1: INORDEN y POSTORDEN: Valor hijo izquierdo de caja actual
# $s2: INORDEN y POSTORDEN: Valor hijo derecho y posterior verificacion de si es hoja
# $s4: INORDEN y POSTORDEN:: Caja cuyo elemento acabo de imprimir
# $s5: INORDEN y POSTORDEN: Caja de comparacion
# $s6: INORDEN y POSTORDEN: Caja padre FIJA
# $s7: POSTORDEN: Verificar para ir caja derecha


# Etiqueta que sirve para inicializar variables para imprimir los ordenes

imprimir: 
	
	# Se inicializan los registros antes descritos
	
	move $t5, $t1
	move $t7, $t1
	move $t6, $t1
	move $t9, $zero
	move $t4, $zero

	# Se hace un salto para que se imprima el arbol inorden
	
	beqz $s4, imprimir_inorden
		
	# Se imprime en pantalla el formato
	
	la $a0, SALTO
	li $v0, 4
	
	syscall
	
	la $a0, SALTO
	li $v0, 4
	
	syscall
	
	la $a0, POSTORDEN
	li $v0, 4
	
	syscall
	
	la $a0, PUNTOS
	li $v0, 4
	
	syscall
	
	la $a0, SALTO
	li $v0, 4
	
	syscall
	
	# Se inicializan unos registros con "basura" para que unas verificaciones en el ciclo de postorden sea falsa.
	
	la $s4, H
	
	move $s6, $s0
	
	li $t8, 1
		
	# Se salta de forma incondicional al postorden
	
	b imprimir_postorden

# Ciclo donde se imprime en inorden el arbol recien creado

imprimir_inorden:

	move $t5, $t6
	
	lw $s1, 4($t5)
	
	lw $s2, 8($t5)
	
	add $s2, $s2, $s1
	
	beqz $s2, hoja_inorden
	
	lw $t6, 4($t5)
	
	beq $t9, $t5, verificar_lado_inorden
	
	beqz $t6, imprimir_raiz_inorden
	
	move $t7, $t5
	
	beq $t4, $t0, imprimir
	
	b imprimir_inorden

# Etiqueta donde se cambia la posicion al hijo derecho de la caja actual

saltar_der_inorden:

	lw $t5, 8($t5)
	
	move $t6, $t5
	
	b imprimir_inorden
	
# Etiqueta donde se verifica si se acaba de imprimir un hijo derecho

verificar_lado_inorden:
	
	lw $s5, 8($t8)
	
	beq $s4,$s5, imprimir_raiz_inorden
	
	move $t9, $t8
	move $t5, $t8
	
	b imprimir_raiz_inorden

# Etiqueta donde se imprime una raiz

imprimir_raiz_inorden:

	# Imprime la raiz del inorden (h_izq-raiz-h_der)

	lw $a0, ($t5)
	li $v0, 1
	
	syscall
	
	la $a0, ESPACIO 
	li $v0, 4
	
	syscall
	
	addi $t4, $t4, 1
	
	move $s6, $t9
	
	move $t9, $t7
	
	b saltar_der_inorden

# Etiqueta donde se imprime una hoja con su respectivo formato

hoja_inorden:

	# Imprime numero de hoja
	
	lw $a0, ($t5)
	li $v0, 1
	
	syscall
	
	# Imprime la "h" de hoja
	
	la $a0, H
	li $v0, 4
	
	syscall
	
	la $a0, ESPACIO 
	li $v0, 4
	
	syscall
	
	addi $t4, $t4, 1
	
	move $s6, $t9
	
	move $s4, $t5 
		
	move $t5, $t1
	move $t6, $t1
	move $t8, $t7

	b imprimir_inorden

# Ciclo donde se imprime en postorden el arbol antes creado

imprimir_postorden:
	
	beq $t4, $t0, fin
	
	lw $t8, 4($t1)
			
	move $t5, $t6
	
	lw $s7, 8($s6)
	
	beq $s4, $s7, actualizar_postorden
	
	move $s6,$t7
	
	lw $s1, 4($t5)
	
	beq $s4, $s1, verificar_der_postorden
	
	lw $s1, 4($t5)
	
	lw $s2, 8($t5)
	
	add $s2, $s2, $s1
	
	beqz $s2, hoja_postorden
	
	lw $t6, 4($t5)
	
	move $t7, $t5
	
	beqz $t6, saltar_der_postorden
	
	beq $t8, $s4, actualizar_t9_postorden

	bnez $t9, saltar_der_postorden
	
	b imprimir_postorden

# Etiqueta donde se verifica si el hijo derecho de la caja actual existe o no.
# En caso de estarlo, se continuan las instrucciones en "saltar_der_postorden"	
	
verificar_der_postorden:

	lw $t6, 8($t5)
	
	move $s6, $t5
	
	move $t7, $t5
	
	beqz $t6, imprimir_raiz_postorden

# Etiqueta donde se carga el valor del hijo derecho para recorrer en postorden dicho subarbol

saltar_der_postorden:

	lw $t6, 8($t5)
	
	b imprimir_postorden

# Etiqueta donde se actualiza el registro $t9 para que se recorra el subarbol derecho de la caja actual

actualizar_t9_postorden:
	
	bnez $t9, cero_t9_postorden
	
	li $t9,1
	
	b imprimir_postorden
	
# Etiqueta donde se imprime una raiz

imprimir_raiz_postorden:

	# Imprime la raiz del postorden (h_izq-h_der-raiz)

	lw $a0, ($t5)
	li $v0, 1
	
	syscall
	
	la $a0, ESPACIO 
	li $v0, 4
	
	syscall
	
	addi $t4, $t4, 1
	
	move $s6, $t7
	
	move $s4, $t5
	
	move $t5, $t1
	move $t6, $t1
	
	b imprimir_postorden
	
# Etiqueta donde se actualiza la caja actual con la caja padre, para que continue el recorrido
	
actualizar_postorden:
	
	move $t5, $s6
	
	b imprimir_raiz_postorden

# Etiqueta donde se actualiza el registro $t9 para que no haya un ciclo infinito en "imprimir_postorden"
	
cero_t9_postorden:

	li $t9, 0
	
	b imprimir_postorden
	
# Etiqueta donde se imprime en una hoja

hoja_postorden:

	# Imprime numero de hoja
	
	lw $a0, ($t6)
	li $v0, 1
	
	syscall
	
	# Imprime la "h" de hoja
	
	la $a0, H
	li $v0, 4
	
	syscall
	
	la $a0, ESPACIO 
	li $v0, 4
	
	syscall
	
	addi $t4, $t4, 1
	
	move $s4, $t6 
	
	move $t5, $t1
	move $t6, $t1

	b imprimir_postorden

# Etiqueta donde se finaliza el programa

fin:

	li $v0, 10
	
	syscall