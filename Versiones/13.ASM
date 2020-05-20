; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Proy_Ensamblador"                   ; What we're called (for file generation)

AppFirst                equ $8000
CHANOPEN                equ 5633
PRINT                   equ 8252                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"       ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ;Start of application

AppEntry                ld a, 2
                        call CHANOPEN                   ;Abrimos canal de escritura

                        call Start                      ;Seteamos toda la interfaz inicial

 Game                   halt
                        halt
                        halt

                        ;call MovePala
                        call MoveBola

                        ld a, (Vidas + 3)
                        cp "0"                           ;Comprobar si vidas == 0
                        jp nz, Game

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


Animacion               halt
                        halt
                        halt
                        ld a, (Bola + 2)
                        ld (Void + 2), a                ;Cargamos en Void
                        call SetVoid                    ;Imprimimos void (en la pos de Bola)

                        ld a, (Bola + 2)
                        inc a                           ;Incrementamos X de Bola

                        ld (Bola + 2), a                ;Reemplazamos X de Bola por Bola+1
                        call SetBola                    ;Imprimir Bola
                        ld a, (Bola + 2)
                        cp 31
                        jp nz, Animacion                    ;Saltar a Animacion si no ha llegado a final


                        ret                             ; va a la animación del final

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
                        call SetVidas
                        ret

ResetBola               ld a, 10
                        ld (Bola + 1), a              ;Poner bola en Y=10
                        ld a, 10
                        ld (Bola + 2), a              ;Poner bola en X random
                        ld a, 10
                        ld (DirBolaY), a              ;Direccion de pelota hacia arriba
                        ret

MasPuntos               ld a, (Puntos + 3)            ;Cogemos contador vidas
                        add 1                         ;Disminuimos una vida
                        ld (Puntos + 3), a            ;reescribimos vida
                        call SetPuntos
                        ret

;MovePala


MoveBola                ld a, (Bola + 2)        ;coordenada X pelota
                        ld (Void + 2), a

                        ld a, (DirBolaX)
                        cp 1                    ;comprobar direccion

                        ld a, (Bola + 2)
                        jp z, dDe

                        dec a                  ;Izquierda
                        jp finHor
dDe                     inc a                  ;derecha
finHor                  ld (Bola + 2), a        ;Guardar en bola nueva pos

                        cp 0                    ;pared izquierda
                        jp nz, testDer
                        ld a, 1
                        ld (DirBolaX), a          ;Cambiar mov hacia derecha

testDer                 cp 31                   ;pared derecha
                        jp nz, movVert
                        ld a, 0
                        ld (DirBolaX), a          ;Cambiar mov hacia izquierda


movVert                 ld a, (Bola + 1)        ;coordenada Y
                        ld (Void + 1), a

                        ld a, (DirBolaY)
                        cp 1

                        ld a, (Bola + 1)
                        jp z, dAb

                        dec a
                        jp finVer
dAb                     inc a
finVer                  ld (Bola + 1), a        ;Guardar en Bola nueva pos

                        cp 1                    ;techo
                        jp nz, testAb
                        ld a, 1
                        ld (DirBolaY), a          ;Cambiar mov abajo

testAb                  cp 20                   ;Suelo?
                        jp nz, endMov

                        ld a, (Pala + 2)
                        ld c, a
                        ld a, (Bola + 2)

                        cp c
                        jp nz, lose

                        call MasPuntos

                        ld a, 0
                        ld (DirBolaY), a          ;Cambiar mov arriba
                        jp endMov

lose                    call MenosVida
                        call ResetBola

endMov                  call SetVoid
                        call SetBola
                        ret

;------------- A partir de aqui variables ------------------------------------------------------------------------


Vidas                   defb 22, 0, 31, "3"             ;[22 pq si, pq mola, pq es la moda]
Puntos                  defb 22, 0, 0, "0"
TextoI               defb 22, 10, 9, "Vertical Pong"
TextoF               defb 22, 10, 11, "Game Over"

Bola                    defb 22, 10, 0, "o"
Pala                    defb 22, 21, 18, "="
Void                    defb 22, 10, 0, " "
DirBolaX                defb 0                         ;0 para izquierda, 1 para derecha
DirBolaY                defb 0                          ;0 para arriba, 1 para abajo


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


