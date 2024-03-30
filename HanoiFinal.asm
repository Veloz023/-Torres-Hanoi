#Integrantes:
#Jaime Antonio Contreras Barragan
#Jose Daniel Diaz Veloz

#ALGORITMO EN C
#include <stdio.h>

#// Función para mover los discos de una torre a otra
#void torresHanoi(int n, int torreOrigen[], int torreAuxiliar[], int torreDestino[]) {
#    if (n == 1) {
#        // Mueve el disco de la torre origen a la torre destino
#        int disco = torreOrigen[0];
#        printf("Mueve el disco %d de la torre %d a la torre %d\n", disco, torreOrigen - torreOrigen + 1, torreDestino - torreDestino + 1);
#        // Elimina el disco de la torre origen
#        torreOrigen[0] = 0;
#        // Añade el disco a la torre destino
#        torreDestino[0] = disco;
#    } else {
#        // Mueve n-1 discos de la torre origen a la torre auxiliar usando la torre destino
#        torresHanoi(n - 1, torreOrigen, torreDestino, torreAuxiliar);
#        // Mueve el disco restante de la torre origen a la torre destino
#        torresHanoi(1, torreOrigen, torreAuxiliar, torreDestino);
#        // Mueve n-1 discos de la torre auxiliar a la torre destino usando la torre origen
#        torresHanoi(n - 1, torreAuxiliar, torreOrigen, torreDestino);
#    }
#}

#int main() {
#    // Número de discos
#    int n = 3;

#    // Definición de las torres como arreglos de enteros
#    int torreA[] = {3, 2, 1};
#    int torreB[] = {0, 0, 0};
#    int torreC[] = {0, 0, 0};

#    // Llama a la función de Torres de Hanoi
#    torresHanoi(n, torreA, torreB, torreC);

#    return 0;
#}

.text
main:
	#Declaracion de variables
	addi s0, zero, 3 # numero de discos
	
	addi t0, zero, 32#32 para dar un salto vertical
	addi t1, zero, 1 #Variable == 1
	addi t2, zero, 0 #Variable i == 0
	
	
	lui s1,0x10010
	addi s1,s1,0 #0x1001000 origen
	lui s2, 0x10010
	addi s2,s2,0x4 #0x1001004 auxiliar
	lui s3, 0x10010
	addi s3,s3,0x8 #0x1001008 destino
	
	addi t3, s1, 0 	#Variable i == 0
	jal CrearArreglo
	
CrearArreglo:bge t2,s0,endarr	# i>=n saltamos a endarr
	addi t2,t2,1	#i++
	sw t2,(t3)	#Guarda i en la posicion de t1
	add t3,t3,t0	#suma 32 a la direccion loo que recorre verticalmente 1	
	jal CrearArreglo#Vuelve a llamar el ciclo for
	
endarr:	#Continuacion del codigo
	jal TorresdeHanoi	#Llamamos a la funcion recusriva
	jal endcode		#Llamamos al final del codigo



#asi recibe los argumentos (int n, int torreOrigen[], int torreAuxiliar[], int torreDestino[])
TorresdeHanoi: beq s0, t1, mov	#if caso base if(n==1)
	
	#push
	addi sp, sp, -20	#Espacio para las variables
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw ra, 16(sp)
	
	#Modificacion de argumentos (n - 1, torreOrigen, torreDestino, torreAuxiliar)
	addi s0, s0,-1	#n-1
	add t6, s2, x0	#varible para hacer swap con la auxiliar
	add s2, s3, x0	#direccion auxiliar = direccion destino 
	add s3, t6, x0	#direccion destino = temporal con direccion auxiliar
	jal TorresdeHanoi #Hanoi(n-1, from_rod, aux_rod, to_rod)
	
	#pop <- n, ra
	#Recuperamos el valor de las varibles
	lw ra, 16(sp)
	lw s3, 12(sp)
	lw s2, 8(sp)
	lw s1, 4(sp)
	lw s0, 0(sp)
	addi sp, sp, 20
	
	#en vez de hacer una llamada al caso base, directamente ponemos el moviento
	#pero debe volver aqui, asi que utilizamos un registro para guardar a donde debe volver
	#(1, torreOrigen, torreAuxiliar, torreDestino)
	jal s11, mov2

	#push
	addi sp, sp, -20	#Espacio para las variables
	sw s0, 0(sp)		
	sw s1, 4(sp)	
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw ra, 16(sp)
	
	#Modificacion de argumentos (n - 1, torreAuxiliar, torreOrigen, torreDestino)
	addi s0, s0,-1	#n-1
	add t6, s1, x0	#varible para hacer swap con la auxiliar
	add s1, s2, x0
	add s2, t6, x0
	jal TorresdeHanoi  #towerOfHanoi(n - 1, aux_rod, to_rod, from_rod);
	
	#pop <- n, ra
	#Recuperamos el valor de las varibles
	lw ra, 16(sp)
	lw s3, 12(sp)
	lw s2, 8(sp)
	lw s1, 4(sp)
	lw s0, 0(sp)
	addi sp, sp, 20
	 
	jalr ra	#Return (Salto a donde vino la llamada)
	
mov:
	 #offset
	addi t5,s0,-1	#temporal valor n recibido -1	
	slli t5, t5,5	#Basicamente es un n*32 (le ponemos 00000, que recorre a la izquierda el resto de numeros.)
	add s4,s1,t5	#Hacemos que el apuntador seundario de la torre orrigen a (n-1)*32 Para que se desplace verticalmente 	
	add s5,s3,t5	#Hacemos que el apuntador seundario de la torre destino a (n-1)*32 Para que se desplace verticalmente 	
	
	#        // Elimina el disco de la torre origen
	#        torreOrigen[0] = 0;
	#        // Añade el disco a la torre destino
	#        torreDestino[0] = disco;

	lw t3,(s4)#Primero guardamos en t3, y la guardamos en en apuntador secundario a origen
	sw zero, (s4)#Borramos lo que guardamos
	sw t3, (s5)#Guardamos en el apuntados a la direccion destino secundaria 

	jalr ra	#Return

mov2:
	 #offset
	addi t5,s0,-1	#temporal valor n recibido -1	
	slli t5, t5,5	#Basicamente es un n*32 (le ponemos 00000, que recorre a la izquierda el resto de numeros.)
	add s4,s1,t5	#Hacemos que el apuntador seundario de la torre orrigen a (n-1)*32 Para que se desplace verticalmente 	
	add s5,s3,t5	#Hacemos que el apuntador seundario de la torre destino a (n-1)*32 Para que se desplace verticalmente 
	
	#        // Elimina el disco de la torre origen
	#        torreOrigen[0] = 0;
	#        // Añade el disco a la torre destino
	#        torreDestino[0] = disco;

	lw t3,(s4)#Primero guardamos en t3, y la guardamos en en apuntador secundario a origen
	sw zero, (s4)#Borramos lo que guardamos
	sw t3, (s5)#Guardamos en el apuntados a la direccion destino secundaria 
	
	jalr zero,s11,0	#Regresamos a la parte media de TorresdeHanoi, osea el registro s11

#ponemos el endcode al final para que termine
endcode: nop