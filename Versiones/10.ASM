; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Proy_Ensamblador"                   ; What we're called (for file generation)

AppFirst                equ $8000
CHANOPEN                equ 5633
PRINT                   equ 8252                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"       ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ;Start of application

AppEntry                ld a, 2                         ;
                        call CHANOPEN                   ;Abrimos canal de escritura

                        call Start                      ;Seteamos toda la interfaz inicial

;Game                  ;call MovePala
                       ;call MoveBola


                        ;ld a, (Vidas + 3)
                        ;cp 0                           ;Comprobar si vidas == 0
                        ;jp z, Game

                        call GameOver                   ;GAME OVER

                        ret

;------------- A partir de aqui funciones -------------------------------------------------------------------------



Start                   call SetVidas                   ;Imprime Vidas

                        call SetPuntos                  ;Imprime Puntos

                        call SetTextoI                  ;Imprime texto inicial

                        call SetBola                    ;Imprime la bola

                        call Animacion                  ;Imprime animacion inicial al inicio del programa

                        call SetPala                    ;Imprime pala en posInicial, en el medio de la pantalla

                        ret


Animacion               ld a, (Bola + 2)
                        ld (Void + 2), a                ;Cargamos en Void
                        call SetVoid                    ;Imprimimos void (en la pos de Bola)

                        ld a, (Bola + 2)
                        inc a                           ;Incrementamos X de Bola

                        ld (Bola + 2), a                ;Reemplazamos X de Bola por Bola+1
                        call SetBola                    ;Imprimir Bola
                        cp 31
                        jp z, finAni                    ;Saltar a finAni

                        jp Animacion

finAni                  ret                             ; va a la animación del final

SetTextoI               ld de, TextoI
                        ld bc, 16                       ;13 carater, +3 pq si
                        call PRINT
                        ret

GameOver                ld de, TextoF
                        ld bc, 12                       ;9 caracter, +3 pq si
                        call PRINT
                        ret

SetVidas                ld de, Vidas
                        ld bc, 4                        ;...
                        call PRINT
                        ret

SetPuntos               ld a, 2

                        ld de, Puntos
                        ld bc, 4
                        call PRINT
                        ret

SetBola                 ld de, Bola
                        ld bc, 4
                        call PRINT
                        ret

SetPala                 ld de, Pala
                        ld bc, 4
                        call PRINT
                        ret

SetVoid                 ld de, Void
                        ld bc, 4
                        call PRINT
                        ret

MenosVida               ld a, (Vidas + 3)               ;Cogemos contador vidas
                        dec a                           ;Disminuimos una vida
                        ld (Vidas + 3), a               ;reescribimos vida
                        ret

ResetBola               ld a, 10
                        ld (Bola + 1), a              ;Poner bola en Y=10
                        ld a, r
                        ld (Bola + 2), a              ;Poner bola en X random
                        ld a, -1
                        ld (DirBolaY), a              ;Direccion de pelota hacia arriba

MasPuntos               ld a, (Puntos + 3)            ;Cogemos contador vidas
                        inc a                         ;Disminuimos una vida
                        ld (Puntos + 3), a            ;reescribimos vida
                        ret

;MovePala              ;movimiento de la pala con el teclado
                       ;'I' mover izquierda
                       ;'P' mover derecha

;MoveBola                ld a, (Bola + 1)        ;coordenada Y
;                        add DirBolaY
;
;                        cp 0                    ;pared izquierda
;
;                       cp 31                   ;pared derecha
;
;                        ld (Bola + 1), a
;
;                        ld a, (Bola + 2)        ;coordenada X
;                        add DirBolaX
;
;                        cp 1                    ;techo
;
;                        cp 23                   ;suelo o plataforma
;                        {
;                                ;cp plataforma
;                                call MasPuntos
;                        }
;                        else
;                                call MenosVida
;
;                        ld (Bola + 2), a

;                        call SetBola
;                        ret

;------------- A partir de aqui variables ------------------------------------------------------------------------


Vidas                   defb 22, 0, 31, "3"             ;[22 pq si, pq mola, pq es la moda]
Puntos                  defb 22, 0, 0, "0"
TextoI               defb 22, 10, 9, "Vertical Pong"
TextoF               defb 22, 10, 11, "Game Over"

Bola                    defb 22, 10, 0, "o"
Pala                    defb 22, 21, 15, "="
Void                    defb 22, 10, 0, " "
DirBolaX                defb -1                         ;-1 para izquierda, 1 para derecha
DirBolaY                defb -1                          ;-1 para arriba, 1 para abajo


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


