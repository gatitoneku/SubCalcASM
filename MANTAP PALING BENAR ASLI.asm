;@2016
;Tema: Program Kalkulator Subnetting IPv4
;Author: M. Yusuf Irfan H.
         Widian Baron
         Kevin Sirait
;Skenario:
;   -User memasukkan input alamat IPv4 dan subnetmasknya
;   -Program akan menghitung Network Address, Wildcard Mask, FUA, LUA dan BA
;  
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;   

.model small
.data

teks db 'Masukkan Address dan netmask.',13,10,'Contoh: xxx.xxx.xxx.xxx/xxx.xxx.xxx.xxx',13,10,13,10,'$' 
teks1 db 13,10,13,10,'Network address:',13,10,'$'                   
teks2 db 13,10,13,10,'Wildcard:',13,10,'$'  
teks3 db 13,10,13,10,'First Usable Address:',13,10,'$'
teks4 db 13,10,'Last Usable Address:',13,10,'$'
teks5 db 13,10,'Broadcast Address:',13,10,'$'
teks6 db 13,10,13,10,'Tekan enter untuk mengulang atau sembarang karakter untuk keluar',13,10,'$'
teks7 db 13,10,13,10,'Input Salah >> Mengulang Program',13,10,13,10,'$'
teks0 db '.000','$'

bit1 dw ? 
bit2 dw ?
bit3 dw ?
bit4 dw ?

sub1 dw 0
sub2 dw 0
sub3 dw 0
sub4 dw 0

wild1 dw ?
wild2 dw ?
wild3 dw ?
wild4 dw ?

temp1 dw ?
pilih db ?

.code
.startup

;macro

;untuk menampilkan kata / kalimat


cetakword   Macro cetakan
            lea dx,cetakan
            mov ah, 9h
            int 21h
            EndM


;untuk menampilkan angka

cetaknum    Macro cetakin
            mov dl, cetakin
            or dl,30h
            mov ah, 2h
            int 21h
            EndM
            
            
cetaklangsung macro langsung
              mov dx,langsung
              mov ah,2h
              int 21h
              endm

;untuk menerima input

ambil   macro ambilan
        mov ah, 1h
        int 21h
        mov ambilan,al
        EndM                      

;untuk menerima byte

byte    macro simpan
        mov cl,10
        mov ch,100
        
        mov ah,01h
        int 21h
        mov ah,0
        sub ax,30h
        
        mul ch   
        add bx,ax
        
        mov ah,01h
        int 21h
        mov ah,0
        sub ax,30h
        
        mul cl
        add bx,ax
        
        mov ah,01h
        int 21h
        mov ah,0
        sub ax,30h 
        
        add bx,ax
        
        mov simpan,bx
        mov bx,0
        
        endm
    
;rumusan mencari nilai wildmask
rumus   macro network,mask,wild
        mov dx,0
        mov dx,mask
        ;mengAND kan dgn subnet mask  1
        and network,dx
        push mask
        pop wild
        xor wild,0FFFFh

        endm

;rumusan untuk mencetak hexadecimal menjadi angka ascii
cetaknetwork    macro network,temp
                mov ax,network
                aam
                mov temp,ax
                mov al,ah
                aam
                add ax,3030h
                push ax
                mov dl,ah
                mov ah,02h
                int 21h
                pop dx
                mov ah,02h
                int 21h
                
                mov dx,temp
                add dl,30h
                mov ah,02h
                int 21h
        endm

cekvalid    macro cek
            cmp cek, 0h           ;cek kevalidan input untuk angka pertama
            jb stop

            cmp cek, 00ffh
            ja stop
 
endm

mulai: 
 
call clearscreen  ;untuk clear screen

cetakword teks

        ;memasukkan byte pertama
        
IP:     byte bit1
        
        cekvalid bit1
        
        ;memberi titik
        cetaklangsung '.' 
        
        ;memasukkan byte kedua
        
        byte bit2
        cekvalid bit2
        ;membuat titik
        cetaklangsung '.'
        
        ;memasukkan byte ketiga
        byte bit3
        cekvalid bit3

        
        ;membuat titik
        cetaklangsung '.'
        
        ;memasukkan byte ke4
        
        byte bit4
        cekvalid bit4
        
        cetaklangsung '/'

        ;memasukkan subnet mask 1
        
subnet: byte sub1
        cekvalid sub1
        
        cmp sub1, 255
        je byte2
        cmp sub1, 128
        je autocomplete1
        cmp sub1, 192
        je autocomplete1
        cmp sub1, 224
        je autocomplete1
        cmp sub1, 240
        je autocomplete1
        cmp sub1, 248
        je autocomplete1
        cmp sub1, 252
        je autocomplete1
        cmp sub1, 254
        je autocomplete1 
        cmp sub1, 0
        je autocomplete1
        jmp stop
        

        
        ;memasukkan subnet mask 2        
byte2:
        cetaklangsung '.'
        byte sub2
        cekvalid sub2
        
        cmp sub2, 255
        je byte3
        cmp sub2, 128
        je autocomplete2
        cmp sub2, 192
        je autocomplete2
        cmp sub2, 224
        je autocomplete2
        cmp sub2, 240
        je autocomplete2
        cmp sub2, 248
        je autocomplete2
        cmp sub2, 252
        je autocomplete2
        cmp sub2, 254
        je autocomplete2 
        cmp sub2, 0
        je autocomplete2
        jmp stop
        

                 
        ;memasukkan subnet mask 3
byte3:
        cetaklangsung '.'
        byte sub3
        cekvalid sub3
        
        cmp sub3, 255
        je byte4
        cmp sub3, 128
        je autocomplete3
        cmp sub3, 192
        je autocomplete3
        cmp sub3, 224
        je autocomplete3
        cmp sub3, 240
        je autocomplete3
        cmp sub3, 248
        je autocomplete3
        cmp sub3, 252
        je autocomplete3
        cmp sub3, 254
        je autocomplete3
        cmp sub3, 0
        je autocomplete3
        jmp stop
        
        
        ;memasukkan subnet mask 4
byte4:
        cetaklangsung '.'
        byte sub4
        cekvalid sub4
        
        cmp sub4, 255
        je autocomplete4
        cmp sub4, 128
        je autocomplete4
        cmp sub4, 192
        je autocomplete4
        cmp sub4, 224
        je autocomplete4
        cmp sub4, 240
        je autocomplete4
        cmp sub4, 248
        je autocomplete4
        cmp sub4, 252
        je autocomplete4
        cmp sub4, 254
        je autocomplete4   
        cmp sub4, 0
        je autocomplete4
        jmp stop
        
        autocomplete1:
        cetakword teks0
        cetakword teks0
        cetakword teks0
        jmp autocomplete4
        
        autocomplete2:
        cetakword teks0
        cetakword teks0
        jmp autocomplete4
        
        autocomplete3:
        cetakword teks0 
        jmp autocomplete4
        
        autocomplete4:
        rumus bit1,sub1,wild1
        rumus bit2,sub2,wild2
        rumus bit3,sub3,wild3
        rumus bit4,sub4,wild4
      
;-------------------------------------------
dis:    ;display network address 1
        cetakword teks1
        
        cetaknetwork bit1,temp1
        cetaklangsung '.'  

        ;display network address  2
        cetaknetwork bit2,temp1
        cetaklangsung '.'  


        ;display network address  3
        cetaknetwork bit3,temp1
        cetaklangsung '.'  

        ;display network address 4
        cetaknetwork bit4,temp1
          

;---------------------  
        ;display wildcard 1
disw:   cetakword teks2 
        
        cetaknetwork wild1,temp1
        cetaklangsung '.'  

        ;display wildcard2
        cetaknetwork wild2,temp1
        cetaklangsung '.'  

        
        ;display wildcard3
        cetaknetwork wild3,temp1
        cetaklangsung '.'  


        ;display wildcard4
        cetaknetwork wild4,temp1
        
        
;-------------------
FUA:    ;FUA 1
        cetakword teks3 
        
        push bit1
        pop temp1
        add temp1,0
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  
 
        ;FUA 2
        push bit2
        pop temp1
        add temp1,0
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  
        
        ;FUA 3
        push bit3
        pop temp1
        add temp1,0
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;FUA 4
        push bit4
        pop temp1
        add temp1,1
        
        
        cetaknetwork temp1,temp1

        
        
        mov dl,0ah
        mov ah,02h
        int 21h 
;--------------------
LUA:    ;LUA 1
        mov dx, offset teks4
        mov ah, 09h 
        int 21h
        
        push bit1
        pop temp1
        mov cx,wild1
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;LUA 2
        push bit2
        pop temp1
        mov cx,wild2
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;LUA 3
        push bit3
        pop temp1
        mov cx,wild3
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        
        ;LUA 4
        push bit4
        pop temp1
        mov cx,wild4
        add temp1,cx
        sub temp1,1
        
        
        cetaknetwork temp1,temp1

        
        mov dl,0ah
        mov ah,02h
        int 21h
;-------------------- 
BA:     ;BA 1
        cetakword teks5
        
        push bit1
        pop temp1
        mov cx,wild1
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;BA2
        push bit2
        pop temp1
        mov cx,wild2
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;BA3
        push bit3
        pop temp1
        mov cx,wild3
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
        cetaklangsung '.'  

        ;BA4
        push bit4
        pop temp1
        mov cx,wild4
        add temp1,cx
        
        
        cetaknetwork temp1,temp1
     


pilihan:    cetakword teks6
            
            ambil pilih
            cmp pilih,0dh
            je mulai
            jne selesai
            

stop:       mov ah,5h
            int 10h
            cetakword teks7 
            
            cetakword teks6
            
            ambil pilih
            cmp pilih,0dh
            je mulai
            jne selesai

selesai:

.exit   

PROC clearscreen
    mov al,03h
    mov ah,0h
    int 10h 
    RET
    ENDP 

end
