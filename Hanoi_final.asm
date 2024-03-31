#Integrantes:
#Jaime Antonio Contreras Barragan
#Jose Daniel Diaz Veloz


########################################################################################################################
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
###########################################################################################################################
.text
main:
	addi s0, zero, 3 # numero de discos
	add a0, zero, zero #sera la copia del numero de discos, aunqie ahora es 0
	lui s1,0x10010
	addi s1,s1,0x0 #0x1001000	origen
	lui s2, 0x10010
	addi s2,s2,0x4 #0x1001004	auxiliar
	lui s3, 0x10010
	addi s3,s3,0x8 #0x1001008	destino
	lui s4,0x10010
	addi s4,s4,0x0 #0x1001000
	lui s5, 0x10010
	addi s5,s5,0x4 #0x1001004
	lui s6, 0x10010
	addi s6,s6,0x8 #0x1001008
	add a1,zero,s0#cantidad de discos en origen
	add a2,zero,zero#0 en auxiliar
	add a3,zero,zero#0 en destino
	add a4,zero,zero#0 en org
	add a5,zero,zero#0 en dest
	addi t0, zero, 32#para movimientos verticales
	add t1, zero, s1#para dar la posicion de origen
#ciclo for para crear arreglo en la torre origen
CrearArreglo:bge a0,s0,endarr#ciclo que terminara en cuando a0 == s0
	addi t2,a0,1	#t2 = a0+1
	sw t2,(t1)	#Guarda a0+1 en la posicion de t1
	add t1,t1,t0	#t1=t1+32
	addi a0,a0,1	#a0++
	jal CrearArreglo#Saltamos para continuar con el ciclo for
#Continuacion del codigo
endarr:
#Aqui t2,t1 queda libre
#Debemos recuperar el valor de a0
	addi t6,zero,1	#declaramos t6 = 1
	jal Hanoi	#Saltamos Hanoi
	jal end		#Saltamos al final
 

Hanoi:beq a0, t6, Mov	#Si a0 es igual a 1 saltamos a Mov
	#push
	addi sp, sp, -20	#Espacio para las variables
	sw a0, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	sw s6, 12(sp)
	sw ra, 16(sp)
	#Modificacion de argumentos
	addi a0, a0,-1
	add t2, s5, zero
	add s5, s6, zero
	add s6, t2, zero
	jal Hanoi #Hanoi(n-1, from_rod, aux_rod, to_rod)
	#pop <- n, ra
	#Recuperamos el valor de las varibles
	lw ra, 16(sp)
	lw s6, 12(sp)
	lw s5, 8(sp)
	lw s4, 4(sp)
	lw a0, 0(sp)
	addi sp, sp, 20
	#offset
	jal s9,Mov2
	#push
	addi sp, sp, -20	#Espacio para las variables
	sw a0, 0(sp)
	sw s4, 4(sp)
	sw s5, 8(sp)
	sw s6, 12(sp)
	sw ra, 16(sp)
	#Modificacion de argumentos
	addi a0, a0,-1
	add t2, s4, zero
	add s4, s5, zero
	add s5, t2, zero
	jal Hanoi #Hanoi(n-1, from_rod, aux_rod, to_rod)
	#pop <- n, ra
	#Recuperamos el valor de las varibles
	lw ra, 16(sp)
	lw s6, 12(sp)
	lw s5, 8(sp)
	lw s4, 4(sp)
	lw a0, 0(sp)
	addi sp, sp, 20
	jalr ra	#Volvemos a donde se nos llamo
Mov:
	jal s11, switch#guardamos el salto a switch en s11
	sub t1,s0,a4	#calculamos la posicion del origen
	slli t1,t1,5	#multiplicacion para para calculo de posicion
	
	add t1,s4,t1#guradamos en t1, la direscion de s4 sumando el calculo para la posicion de t1
	lw t2,(t1)#agarramos la palabra alojada en t1
	sw zero,(t1)#cambiamos a 0
	sub t1,s0,a5#Calculamos la posicion del destino
	addi t1,t1,-1	#aqui revisar que pedo cuando el disco s 0 
	slli t1,t1,5	#Calculo t1(2^5)
	#mul t1,t1,t0
	add t1,s6,t1	#sumamos a la direccion el t1
	sw t2,(t1)	#Guardamos la el valor de t2 en la direccion t1
	jalr ra		#Volvemos a donde se nos llamo
switch:
	beq s4,s1,case1#Salta al case 1 si s4 es igual a la torre origen
	beq s4,s2,case2#Salta al case 2 si s4 es igual a la torre auxiliar
	beq s4,s3,case3#Salta al case 3 si s4 es igual a la torre destino
label:
	beq s6,s1,case4#Salta al case 1 si s6 es igual a la torre origen
	beq s6,s2,case5#Salta al case 1 si s6 es igual a la torre auxiliar
	beq s6,s3,case6#Salta al case 1 si s6 es igual a la torre destino
case1:
	add a4,zero,a1#El valor de discos en a4 es igual el valor de disco de la torre origen
	addi, a1,a1,-1#Le restamos 1 disco a el valor original de discos de la torre origen
	jal zero, label#Hace un salto a label , y le damos 0 al program counter
case2:
	add a4,zero,a2#El valor de discos en a4 es igual el valor de disco de la torre auxiliar
	addi a2,a2,-1#Le restamos 1 disco a el valor original de discos de la torre auxiliar
	jal zero, label#Hace un salto a label , y le damos 0 al program counter
case3:
	add a4,zero,a3#El valor de discos en a4 es igual el valor de disco de la torre destino
	addi a3,a3,-1#Le restamos 1 disco a el valor original de discos de la torre destino
	jal zero, label#Hace un salto a label , y le damos 0 al program counter
case4:
	add a5,zero,a1#El valor de discos en a5 es igual el valor de disco de la torre origen
	addi a1,a1,1#Le sumamoss 1 disco a el valor original de discos de la torre origen
	jalr zero,s11,0#Hace un salto a s11 registrando 0
case5:
	add a5,zero,a2#El valor de discos en a5 es igual el valor de disco de la torre auxiliar
	addi a2,a2,1#Le sumamoss 1 disco a el valor original de discos de la torre auxiliar
	jalr zero,s11,0#Hace un salto a s11 registrando 0
case6:
	add a5,zero,a3#El valor de discos en a5 es igual el valor de disco de la torre destino
	addi a3,a3,1#Le sumamoss 1 disco a el valor original de discos de la torre destino
	jalr zero,s11,0#Hace un salto a s11 registrando 0
 
Mov2:
	jal s10, switch2	#guardamos el salto a switch en s10
	sub t1,s0,a4	#calculamos la posicion del origen
	slli  t1,t1,5	#Recorrimiento de bits para que sea t1(2^5)
	add t1,s4,t1	#guradamos en t1, la direscion de s4 sumando el calculo para la posicion de t1
	lw t2,(t1)	#agarramos la palabra alojada en t1
	sw zero,(t1)	#cambiamos a 0
	sub t1,s0,a5	#Calculamos la posicion del destino
	addi t1,t1,-1	#aqui revisar que pedo cuando el disco s 0 
	slli t1,t1,5	#Calculo t1(2^5)
	add t1,s6,t1	#sumamos a la direccion el t1
	sw t2,(t1)	#Guardamos la el valor de t2 en la direccion t1
	jalr zero,s9,0	#saltamos registrando sero a s9 (que nos devuelve a mitad a torres de hanoi)
switch2:
	beq s4,s1,case10#Salta al case 10 si s4 es igual a la torre origen
	beq s4,s2,case20#Salta al case 20 si s4 es igual a la torre auxiliar
	beq s4,s3,case30#Salta al case 30 si s4 es igual a la torre destino
label2:
	beq s6,s1,case40#Salta al case 40 si s6 es igual a la torre origen
	beq s6,s2,case50#Salta al case 50 si s6 es igual a la torre auxiliar
	beq s6,s3,case60#Salta al case 60 si s6 es igual a la torre destino
case10:
	add a4,zero,a1	#El valor de discos en a4 es igual el valor de disco de la torre origen
	addi, a1,a1,-1	#Le restamos 1 disco a el valor original de discos de la torre origen
	jal zero, label2#Hace un salto a label 2, y le damos 0 a return address
case20:
	add a4,zero,a2	#El valor de discos en a4 es igual el valor de disco de la torre auxiliar
	addi a2,a2,-1	#Le restamos 1 disco a el valor original de discos de la torre auxiliar
	jal zero, label2#Hace un salto a label 2, y le damos 0 a return address
case30:
	add a4,zero,a3	#El valor de discos en a4 es igual el valor de disco de la torre destino
	addi a3,a3,-1 	#Le restamos 1 disco a el valor original de discos de la torre destino
	jal zero, label2 #Hace un salto a label 2, y le damos 0 a return address
case40:
	add a5,zero,a1	#El valor de discos en a5 es igual el valor de disco de la torre origen
	addi a1,a1,1	#Le sumamos 1 disco a el valor original de discos de la torre origen
	jalr zero,s10,0	#Hace un salto a s10 registrando 0
case50:
	add a5,zero,a2	#El valor de discos en a5 es igual el valor de disco de la torre auxiliar  
	addi a2,a2,1	#Le sumamos 1 disco a el valor original de discos de la torre auxiliar
	jalr zero,s10,0	#Hace un salto a s10 registrando 0
case60:
	add a5,zero,a3	#El valor de discos en a5 es igual el valor de disco de la torre destino  
	addi a3,a3,1	#Le sumamos 1 disco a el valor original de discos de la torre destino
	jalr zero,s10,0	#Hace un salto a s10 registrando 0
	
#nop al final del codigo para que se salga
end: nop
