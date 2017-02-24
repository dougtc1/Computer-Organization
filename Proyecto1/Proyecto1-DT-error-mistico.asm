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
# $t5: Direccion de caja hija (Caja recien creada)
# $t6: Valor auxiliar (Para comparar y elegir camino)
# $t7: Direccion de caja padre (Caja de elemento anterior)
# $t8: Valor de hijo a tomar (izq o der)
# $t9: Determina si es hijo izq o der
# $s0: Direccion del arreglo VALORES
# $s1: Direccion del arreglo ES_HOJA

	
	.data
	
	VALORES: .word 42, 35, 7, 8, 38, 70, 45, 101, 300
	ES_HOJA: .byte 0, 0, 0, 1, 1, 0, 1, 0, 1
	TAMANO: .word 9	
#	RAIZ: .space 16	# En RAIZ se guarda la direccion de la raiz del arbol

	.text
	
main:
	# Inicializacion
	
	la $s0, VALORES
	la $s1, ES_HOJA
	lw $t0, TAMANO
#	la $t1, RAIZ
	li $t4, 1

	# Inicializacion de RAIZ

	li $v0, 9
	li $a0, 16
	syscall
	
	move $t1,$v0
		
	lw $t2, ($s0)
	sw $t2, ($t1)
	sw $zero, 4($t1)
	sw $zero, 8($t1)
	lb $t3, ($s1)
	sw $t3, 12($t1)

ciclo1:

	lw $t6, ($t1)
	
	move $t7, $t1
	
	beq $t4, $t0, imprimir
	
	addi $t4, $t4, 1
	
	addi $s0, $s0, 4
	
	addi $s1, $s1, 1
	
	lw $t2, ($s0)
	lb $t3, ($s1)
	
	li $v0, 9
	li $a0, 16
	syscall
	
	move $t5,$v0
	
	# Aqui se "inicializa" la caja recien creada
	
	sw $t2, ($t5)
	sw $zero, 4($t5)
	sw $zero, 8($t5)
	sw $t3, 12($t5)
	
	b comparar
	
comparar:

	blt $t2, $t6, hijo_izq
	
	bgt $t2, $t6, hijo_der
	
	
# Tenemos que construir los ciclos de hijo izq e hijo der, esto es, despues de hacer la verificacion hay que preguntar si se salta
# a hijo izq o hijo der y como ultima instruccion, saltar a un label agregar, donde, despues de agregar se salta al ciclo 


hijo_izq:
	
	lw $t8, 4($t7)
	li $t9, 4
	beqz $t8, agregar
	move $t7, $t8
	lw $t6, ($t7)  
	b comparar

hijo_der:

	lw $t8, 8($t7)
	li $t9, 8
	beqz $t8, agregar
	move $t7, $t8
	lw $t6, ($t7)
	b comparar

agregar:
	
	add $s2, $t8, $t9

	lw $t7, ($s2)
	
	b ciclo1
	
imprimir:
	li $t9, 9999
	
	
	
	
