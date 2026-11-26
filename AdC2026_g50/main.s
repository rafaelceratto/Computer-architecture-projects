// Inicializacion:

    MOVZ X10, #0x8000        // X10 = GPIO input
    MOVZ X11, #0x8008        // X11 = GPIO output
    MOVZ X12, #0x0001        // X12 = bit para SW0
    MOVZ X14, #0x000E        // X14 = bits SW1..3
    MOVZ X17, #1             // Constante 1
    MOVZ X20, #1             // LED actual (arranca en LED0)
    MOVZ X21, #0xFFFF        // Todos prendidos
    MOVZ X22, #0x000E        // 3 switches
    MOVZ X23, #0x0002        // solo SW1
    MOVZ X24, #0x0004        // solo SW2
    MOVZ X25, #0x0008        // solo SW3
    MOVZ X26, #1             // Retardo velocidad maxima (3 switches)
    MOVZ X27, #4             // Retardo velocidad media  (2 switches)
    MOVZ X28, #8             // Retardo velocidad minima (1 switch)

loop:
    LDUR X15, [X10, #0]      // X15 = Estado actual de los switches
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    AND  X1, X15, X12        // X1 = estado de SW0
    AND  X3, X15, X14        // X3 = estado de SW1..3
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

    CBZ  X1, sw0_es_cero
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

    CBZ  XZR, efecto_leds    // Si SW0 esta activo entonces hago el efecto
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

sw0_es_cero:
    CBZ  X3, todos_apagados  // Si no hay ningun SW de velocidad activo apago todo
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

    STUR X21, [X11, #0]      // Si hay alguno prendo todos
    CBZ  XZR, loop           // Vuelvo a chequear el estado de los siwtches
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

todos_apagados:
    STUR XZR, [X11, #0]      // Apago los leds 
    CBZ  XZR, loop           // Vuelvo a chequear el estado de los switches
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

efecto_leds:
    CBZ  X3, efecto_inicial  // Si no hay velocidad, LED0 fijo
    ADD  XZR, XZR, XZR
    ADD  XZR, XZR, XZR
    ADD  XZR, XZR, XZR

    CBZ  XZR, efecto_con_velocidad
    ADD  XZR, XZR, XZR
    ADD  XZR, XZR, XZR
    ADD  XZR, XZR, XZR

efecto_inicial:
    STUR X17, [X11, #0]      // LED0 fijo (X17 = 1)
    ADD  X20, XZR, X17       // Para que el efecto vuelva al Led0 si se desactiva la velocidad 
    CBZ  XZR, loop           // Vuelvo a chequear el estado de los switches
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

efecto_con_velocidad:
    STUR X20, [X11, #0]      // mostrar LED actual
                             // X3 estado de los SW1..3 
    SUB  X6, X3, X22         // X22 = Estan activos los 3 switches 
    SUB  X7, X3, X23         // X23 = Esta activo SW1 
    SUB  X8, X3, X24         // X24 = Esta activo SW2
    SUB  X9, X3, X25         // X25 = Esta actico SW3

    CBZ  X6, velocidad_max   // Si estan activos los 3 --> Velocidad maxima
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  X7, velocidad_min   // Si esta activo solo SW1 --> Velocidad minima
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  X8, velocidad_min   // Si esta activo solo SW2 --> Velocidad minima
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  X9, velocidad_min   // Si esta activo solo SW3 --> Velocidad minima
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

velocidad_med:               // En el caso que no haya saltado --> estan activos 2 switches, no importan cuales
    ADD  X16, XZR, X27       // X16 = retardo medio
    CBZ  XZR, delay_loop     // Salto al delay 
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

velocidad_max:
    ADD  X16, XZR, X26       // X16 = retardo maximo
    CBZ  XZR, delay_loop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

velocidad_min:
    ADD  X16, XZR, X28       // X16 = retardo minimo
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

delay_loop:
    SUB  X16, X16, X17       // Voy decrementando el contador
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  X16, avanzo_leds    // Si ya termino de esperar salto 
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  XZR, delay_loop     // Sino sigue esperando
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

avanzo_leds:
    SUB  X6, X20, X10        // X10 = 0x8000 = bit del LED15
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    CBZ  X6, reinicio_efecto // Si X6 es 0 es porque X20 era el led 15 (llego al final)
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

    ADD  X20, X20, X20       // Corro una posicion hacia la izquierda (avanzo)
    CBZ  XZR, loop           // Vuelvo al loop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop

reinicio_efecto:
    ADD  X20, XZR, X17       // vuelvo al LED0
    CBZ  XZR, loop           // Vuelvo al loop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
    ADD  XZR, XZR, XZR       // Nop
