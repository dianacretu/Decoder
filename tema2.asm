
extern puts
extern printf
extern strlen
extern strstr

section .data
filename: db "./input.dat",0
inputlen: dd 2263
fmtstr: db "Key: %d",0xa,0

section .text
global main

; TODO: define functions and helper functions
extragere_siruri:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]
    push    edi
    call    strlen              ;aflam lungimea sirului
    add     esp, 4
    inc     eax                 ;pentru a trece de terminatorul de sir
    add     edi, eax            ;trecem de primul sir
    mov     eax, edi            ;obtinem cel de-al doilea sir
    leave
    ret

xor_strings:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]      ;cuvantul
    mov     esi, [ebp + 12]     ;cheia
continue_xor:
    mov     al, byte [edi]      ;copiem primul octet din cuvant
    mov     ah, byte [esi]      ;copiem primul octet din cheie
    xor     al, ah
    mov     byte [edi], al      ;se suprascrie octetul din cuvant
    inc     edi                 ;inaintam la urmatorul octet
    inc     esi
    cmp     byte [edi], 0x00    ;verificare daca s-a ajuns la finalulu sirului
    jne     continue_xor
    leave 
    ret
    
rolling_xor:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]
    push    edi
    call    strlen
    add     esp,4
    add     edi,eax             ;mutam pointerul la finalul sirului
    dec     edi                 ;ultimul caracter, nu terminatorul de sir
keep_rolling:
    mov     ah, byte [edi]      ;caracterul de pe pozitia curenta
    dec     edi                 
    cmp     byte [edi], 0x00    ;verificam daca nu s-a terminat sirul
    je      end_rolling
    mov     al, byte [edi]      ;octetul de pe pozitia precedenta
    xor     ah, al              ;decodarea
    inc     edi                 
    mov     byte [edi], ah      ;se muta noul octet obtinut pe pozitia curenta din sir
    dec     edi                 ;se muta pozitia cu un octet spre inceput
    jmp     keep_rolling
end_rolling:
    inc     edi                 ;pointerul sa arate spre inceputul sirului modificat
    mov     eax, edi 
    leave 
    ret
    
convert_hex:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]
    mov     esi, edi            ;un sir auxiliar
    mov     eax, esi            ;ramane setat la inceputul noului sir
do:
    xor     ecx,ecx
    mov     ch, byte [edi]      ;primul octet reprezinta ce-a de-a doua cifra a nr in hexa
    cmp     ch, 58              ;verificam daca este cifra, folosindu-ne de codul ASCII
    jl      number
    sub     ch, 87              ;in caz ca este litera
    jmp     convert
number:
    sub     ch, 48
convert:
    shl     ch, 4               ;inmultirea cu 16
    inc     edi                 ;trecem la urmatorul octet
    mov     cl, byte [edi]      ;prima cifra a nr din hexa     
    cmp     cl, 58              
    jl      number2
    sub     cl, 87
    jmp     convert2
number2:
    sub     cl, 48
convert2:
    add     ch, cl              ;le adunam pentru a obtine nr convertit
    mov     byte [esi], ch      ;mutam rezultatul intr-un nou sir pe un singur octet
    inc     esi                 ;inaintam in sir
    inc     edi
    cmp     byte [edi], 0x00    ;verificam daca s-a terminat de parcurs sirul
    jne     do
    mov     byte [esi], 0x00    ;punem terminatorul de sir pentru noul sir obtinut
    leave 
    ret
    
xor_hex_strings:
    push    ebp
    mov     ebp, esp
    mov     ebx, [ebp + 8]
    mov     edx, [ebp + 12]
    push    ebx                ;primul sir pentru a fi convertit din hexa
    call    convert_hex
    add     esp, 4
    push    eax                ;sirul transformat in binar este pus pe stiva
    push    edx                ;cel de-al doilea sir in hexa
    call    convert_hex
    add     esp, 4
    mov     edx, eax            ;se pune in edx cel de-al doilea sir convertit
    pop     eax
    push    edx
    push    eax
    call    xor_strings
    add     esp, 8
    mov     eax, ebx            ;primul sir suprascris
    leave 
    ret
    
find_decoded:
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]
    mov     ebx, [ebp + 12]
    xor     eax, eax
find_decod:
    mov     al, byte [esi]
    xor     al, bl
    mov     byte [esi], al
    inc     esi
    cmp     byte [esi], 0x00
    jne     find_decod
    leave 
    ret
    
bruteforce_singlebyte_xor:
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]
    xor     ebx, ebx
    mov     edi, esi
find_key:
    push    ebx
    push    esi
    call    find_decoded           ;se face xor intre cheie si string
    add     esp, 8
    mov     esi, edi
    sub     esp, 6                  
    mov     byte [esp], 'f'
    mov     byte [esp + 1], 'o'
    mov     byte [esp + 2], 'r'
    mov     byte [esp + 3], 'c'
    mov     byte [esp + 4], 'e'
    mov     byte [esp + 5], 0x00   ;stringul "force" este pus pe stiva
    mov     eax, esp               ;este mutat intr-un registru
    push    eax
    push    edi
    call    strstr                 ;se cauta "force" in sirul decodat
    add     esp, 8
    cmp     eax, 0x00              ;in eax va fi null daca nu este gasit
    jne     found_key              ;bucla se termina cand este gasit
    push    ebx
    push    esi
    call    find_decoded           ;sirul este adus la forma initiala
    add     esp, 4
    mov     esi, edi
    inc     bl                     ;se trece la urmatoarea cheie
    jmp     find_key
found_key:    
    leave 
    ret
    

binary:
    push    ebp
    mov     ebp, esp   
    mov     eax, [ebp + 8]
bucla:
    cmp     byte [eax], 'A'
    jge     litera
    sub     byte [eax], 24
    jmp     cont
litera:
    sub     byte [eax], 'A'
cont:
    inc     eax
    cmp     byte [eax], '='
    jne     bucla    
    leave 
    ret
    
base32decode:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]    
    xor     eax, eax
    xor     edx, edx
cd:
    mov     bl, byte [edi + edx]
    shl     bl, 3
    mov     bh, byte [edi + edx + 1]
    shr     bh, 2
    add     bl, bh                      ;1
    mov     byte [edi + eax], bl
    mov     bl, byte [edi + edx + 1]
    shl     bl, 6
    mov     bh, byte [edi + edx + 2]
    shl     bh, 1
    add     bl, bh
    mov     bh, byte [edi + edx + 3]
    shr     bh, 4
    add     bl, bh
    mov     byte [edi + eax + 1], bl   ;2
    cmp     byte[edi + edx + 4], '='       ; tratez padding-ul
    je      exit
    mov     bl, byte [edi + edx + 3]
    shl     bl, 4
    mov     bh, byte [edi + edx + 4]
    shr     bh, 1
    add     bl, bh
    mov     byte [edi + eax + 2], bl       ;3
    mov     bl, [edi + edx + 4]
    shl     bl, 7
    mov     bh, [edi + edx + 5]
    shl     bh, 2
    add     bl, bh
    mov     bh, [edi + edx + 6]
    shr     bh, 3
    add     bl, bh   
    mov     byte [edi + eax + 3], bl       ;4    
    mov     bl, [edi + edx + 6]
    shl     bl, 5
    mov     bh, [edi + edx + 7]
    add     bl, bh    
    mov     byte [edi + eax + 4], bl        ;5    
    add     edx, 8
    add     eax, 5    
    cmp     byte [edi + edx], 0x00
    jne     cd    
exit:
    mov     byte[edi + eax + 2], 0          ;adaug null
    leave 
    ret


main:
    mov     ebp, esp; for correct debugging
    push    ebp
    mov     ebp, esp
    sub     esp, 2300
    
    ; fd = open("./input.dat", O_RDONLY);
    mov eax, 5
    mov ebx, filename
    xor ecx, ecx
    xor edx, edx
    int 0x80
    
	; read(fd, ebp-2300, inputlen);
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80

	; close(fd);
	mov eax, 6
	int 0x80
      
        
	; all input.dat contents are now in ecx (address on stack)
        push ecx                    ;pus pe stiva pentru a nu fi modificat
        push ecx
        call extragere_siruri
        add esp, 4
        pop ecx     
        mov edx, eax                ;in edx se afla cheia
       

	; TASK 1: Simple XOR between two byte streams
	; TODO: compute addresses on stack for str1 and str2
	; TODO: XOR them byte by byte
        push edx 
        push ecx
        call xor_strings
	add esp, 8

	; Print the first resulting string
        push edx
        push ecx
        call puts
	add esp, 4
        pop edx
        
         push edx
         call extragere_siruri
         add esp, 4
         mov ebx, eax       

	; TASK 2: Rolling XOR
	; TODO: compute address on stack for str3
	; TODO: implement and apply rolling_xor function
        mov edi, ebx
        push ebx
        call rolling_xor
	add esp, 4
        
        
	; Print the second resulting string
	push eax
	call puts
	add esp, 4

        
        push ebx
        call extragere_siruri
        add esp, 4
        mov edi, eax
        mov ebx, eax
        
        push ebx
        call extragere_siruri
        add esp, 4
        mov esi, eax
     
	; TASK 3: XORing strings represented as hex strings
	; TODO: compute addresses on stack for strings 4 and 5
	; TODO: implement and apply xor_hex_strings
        
	push esi
	push ebx
	call xor_hex_strings
	add esp, 8


	; Print the third string
        mov edx, eax
        push edx
	push eax
	call puts
	add esp, 4
        
	
	; TASK 4: decoding a base32-encoded string
	; TODO: compute address on stack for string 6
	; TODO: implement and apply base32decode
        call extragere_siruri
        add esp, 4
        mov esi, eax
       

	; TASK 5: Find the single-byte key used in a XOR encoding
	; TODO: determine address on stack for string 7
	; TODO: implement and apply bruteforce_singlebyte_xor
        push esi
        call extragere_siruri
        add esp, 4
        mov esi, eax
     
        push esi
        push esi
        call extragere_siruri
        add esp, 4
        
        pop esi
        
        mov esi, eax
        
        
        
        
        push esi
        call extragere_siruri
        add esp, 4
        mov esi, eax
        
        push esi
        call extragere_siruri
        add esp, 4
        PUSH EAX
        
       
        push esi
        call binary
        add esp, 4
        push esi
        call base32decode
        add esp, 4   
        push esi
        call puts
        add esp, 4       
        pop esi      
        xor ebx, ebx
	push ebx
	push esi
	call bruteforce_singlebyte_xor
	add esp, 8

	; Print the fifth string and the found key value
	push edi
	call puts
	add esp, 4

	push ebx
	push fmtstr
	call printf
	add esp, 8

	; TASK 6: Break substitution cipher
	; TODO: determine address on stack for string 8
	; TODO: implement break_substitution
	;push substitution_table_addr
	;push addr_str8
	;call break_substitution
	;add esp, 8

	; Print final solution (after some trial and error)
	;push addr_str8
	;call puts
	;add esp, 4

	; Print substitution table
	;push substitution_table_addr
	;call puts
	;add esp, 4

	; Phew, finally done
    xor eax, eax
  ;  mov esp, ebp
    leave
    ret
