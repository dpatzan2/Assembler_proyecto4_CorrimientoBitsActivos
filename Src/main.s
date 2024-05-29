.equ    RCC_BASE,        0x40023800        // Dirección base del RCC
.equ    AHB1ENR_OFFSET,  0x30              // Desplazamiento del registro de habilitación AHB1
.equ    RCC_AHB1ENR,     (RCC_BASE + AHB1ENR_OFFSET) // Dirección del registro de habilitación AHB1 del RCC
.equ    GPIOA_EN,        (1 << 0)          // Habilitar reloj para GPIOA (establecer bit 0)

/*--------------------------------------------------
DEFINICIONES PARA CONFIGURAR LOS PUERTOS A
--------------------------------------------------*/
.equ    GPIOA_BASE,      0x40020000        // Dirección base del GPIOA
.equ    GPIOA_MODER_OFFSET, 0x00           // Desplazamiento del registro de modo de GPIOA
.equ    GPIOA_MODER,     (GPIOA_BASE + GPIOA_MODER_OFFSET) // Dirección del registro de modo de GPIOA
.equ    MODER0_OUT,      (1 << 0)
.equ    MODER1_OUT,      (1 << 2)
.equ    MODER8_OUT,      (1 << 16)
.equ    MODER9_OUT,      (1 << 18)
.equ    MODER4_OUT,      (1 << 8)
.equ    MODER5_OUT,      (1 << 10)
.equ    MODER6_OUT,      (1 << 12)
.equ    MODER7_OUT,      (1 << 14)          // Configurar PA6 como salida

/*--------------------------------------------------
DEFINICIONES PARA CONTROLAR LOS PUERTOS
--------------------------------------------------*/
.equ    GPIOA_ODR_OFFSET, 0x14             // Desplazamiento del registro de datos de salida de GPIOA
.equ    GPIOA_ODR,       (GPIOA_BASE + GPIOA_ODR_OFFSET) // Dirección del registro de datos de salida de GPIOA

.equ    LED0_ON,         (1 << 0)
.equ    LED1_ON,         (1 << 1)
.equ    LED8_ON,         (1 << 8)
.equ    LED9_ON,         (1 << 9)
.equ    LED4_ON,         (1 << 4)
.equ    LED5_ON,         (1 << 5)
.equ    LED6_ON,         (1 << 6)
.equ    LED7_ON,         (1 << 7)

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb
.section .text
.globl __main

__main:

    // Habilitar reloj para GPIOA
    ldr r0, =RCC_AHB1ENR  // Cargar la dirección de RCC_AHB1ENR en r0
    ldr r1, [r0]          // Cargar el valor en la dirección encontrada en r0 en r1
    orr r1, r1, #GPIOA_EN // Establecer el bit para habilitar el reloj de GPIOA
    str r1, [r0]          // Almacenar el valor modificado de nuevo en RCC_AHB1ENR

    // Configurar GPIOA pines como salida
    ldr r0, =GPIOA_MODER  // Cargar la dirección de GPIOA_MODER en r0
    ldr r1, [r0]          // Cargar el valor en la dirección encontrada en r0 en r1
    orr r1, r1, #MODER0_OUT
    orr r1, r1, #MODER1_OUT
    orr r1, r1, #MODER8_OUT
    orr r1, r1, #MODER9_OUT
    orr r1, r1, #MODER4_OUT
    orr r1, r1, #MODER5_OUT
    orr r1, r1, #MODER6_OUT
    orr r1, r1, #MODER7_OUT
    str r1, [r0]

loop:
    // Estado 1: LEDs 1-7 encendidos, LED 8 apagado
    ldr r0, =GPIOA_ODR
    ldr r1, =(LED0_ON | LED1_ON | LED8_ON | LED9_ON | LED4_ON | LED5_ON | LED6_ON)
    str r1, [r0]
    bl delay

    // Estado 2: LEDs 1-6 encendidos, LEDs 7-8 apagados
    ldr r1, =(LED0_ON | LED1_ON | LED8_ON | LED9_ON | LED4_ON | LED5_ON)
    str r1, [r0]
    bl delay

    // Estado 3: LEDs 1-5 encendidos, LEDs 6-8 apagados
    ldr r1, =(LED0_ON | LED1_ON | LED8_ON | LED9_ON | LED4_ON)
    str r1, [r0]
    bl delay

    // Estado 4: LEDs 1-4 encendidos, LEDs 5-8 apagados
    ldr r1, =(LED0_ON | LED1_ON | LED8_ON | LED9_ON)
    str r1, [r0]
    bl delay

    // Estado 5: LEDs 1-3 encendidos, LEDs 4-8 apagados
    ldr r1, =(LED0_ON | LED1_ON | LED8_ON)
    str r1, [r0]
    bl delay

    // Estado 6: LEDs 1-2 encendidos, LEDs 3-8 apagados
    ldr r1, =(LED0_ON | LED1_ON)
    str r1, [r0]
    bl delay

    // Estado 7: LED 1 encendido, LEDs 2-8 apagados
    ldr r1, =(LED0_ON)
    str r1, [r0]
    bl delay

    // Estado 8: Todos los LEDs apagados
    ldr r1, =0
    str r1, [r0]
    bl delay

    b loop

delay:
    ldr r3, =0xE4E1C0   // Valor para el delay aproximandamente de 1.5 segundos
delay_loop:
    subs r3, r3, #1     // Decrementar el contador de retraso
    bne delay_loop      // Repetir el bucle si el contador no es cero
    bx lr               // Retorno de la función de retraso

.section .data
.align
.end
