; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "Proyecto Ensamblador"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)
CHANOPEN                equ 5633
PRINT                   equ 8252

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)------------------------------

                        org AppFirst                    ; Start of application

AppEntry                call Start                      ;Seteamos toda la interfaz inicial

;Game                    call MovePala
;                        call MoveBola

                        call GameOver

                        ret




;------------- A partir de aqui funciones -------------------------------------------------------------------------

Start                   call SetVidas                      ;Imprime Vidas

                        call SetPuntos                      ;Imprime Puntos

                        ld de, SetTextoI
                        ld bc, 16                       ;13 carater, +3 pq si
                        call PRINT                      ;Imprime texto inicial

                        call SetBola

                        call Animacion                  ;Imprime animacion inicial

                        call SetPala                      ;Imprime pala en posInicial

                        ret



Animacion               ld a, (Bola + 2)
                        ld (Void + 2), a
                        ;call SetVoid

                        ld a, (Bola + 2)
                        inc a

                        ld (Bola + 2), a
                        call SetBola

                        ;ld bc, 31d
                        ;cpi
                        ;jp z, finAni

                        jp pe, Animacion

finAni                  ret



GameOver                ld a, 2
                        call CHANOPEN

                        ld de, SetTextoF
                        ld bc, 12                       ;9 caracter, +3 pq si
                        call PRINT

                        ret

SetVidas                ld a, 2
                        call CHANOPEN

                        ld de, Vidas
                        ld bc, 4
                        call PRINT

SetPuntos                ld a, 2
                        call CHANOPEN

                        ld de, Puntos
                        ld bc, 4
                        call PRINT


SetBola                 ld a, 2
                        call CHANOPEN

                        ld de, Bola
                        ld bc, 4h
                        call PRINT

                        ret

SetPala                 ld a, 2
                        call CHANOPEN

                        ld de, Pala
                        ld bc, 4
                        call PRINT

                        ret

SetVoid                 ld a, 2
                        call CHANOPEN

                        ld de, Void
                        ld bc, 4
                        call PRINT

                        ret


;MovePala

;MoveBola


;------------- A partir de aqui variables ------------------------------------------------------------------------


Vidas                   defb 22, 0, 31, "3"             ;[22 pq si, pq mola, pq es la moda]
Puntos                  defb 22, 0, 0, "0"
SetTextoI               defb 22, 10, 9, "Vertical Pong"
SetTextoF               defb 22, 10, 11, "Game Over"

Bola                    defb 22, 10, 0, "o"
Pala                    defb 22, 21, 15, "="
Void                    defb 22, 10, 0, " "
DirBolaX                defb -1                         ;-1 para izquierda, 1 para derecha
DirBolaY                defb 1                          ;1 para arriba, -1 para abajo


; Stop planting code after this. (When generating a tape file we save bytes below here)-----------------------------


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


