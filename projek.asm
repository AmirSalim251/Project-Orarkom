;-----------------------------------------------------------------------
; Kelompok : 4		                                                    |
; Nama 	   :    1. Amir Salim(140810210015)                             |
;	            2. Muhammad Fauzan Azzhima(140810210041)                |
;	            3. Ibrahim Dafi iskandar(140810210039)                  |
; Kelas    : A					                                        |
;-----------------------------------------------------------------------



org 0x100               ;Origin 100h yang menandakan ruang kosong sebanyak 100h di atas program

global start            ;Deklarasi global start

%macro write_string 1                   
                        ;Penggunaan makro/fungsi untuk menampilkan data string
	mov dx,%1           ;Memasukkan string/atau data ke dx
	mov ah,0x9          ;Inisialisasi pemanggilan interupt untuk pring string ke terminal yaitu memindahkan
                        ;0x9 ke ah
	int 0x21            ;Melakukan interupt 0x21
%endmacro               
section .text           ;Section text untuk src program

menu:                                       ;Label menu
    write_string newline                    ;Print string untuk baris baru / '\n'
	write_string pembukaan                  ;Print string untuk header menu
	write_string newline                    ;Print string untuk baris baru / '\n'
	write_string pil1                       ;Print string pilihan pertama (decimal -> binary)
	write_string newline                    ;Print string untuk baris baru / '\n'
	write_string pil2                       ;Print string untuk pilihan kedua (binary -> decimal)
	write_string newline                    ;Print string untuk baris baru / '\n'
    write_string pil3                       ;Print string untuk pilihan ketiga (keluar program)
    write_string newline                    ;Print string untuk baris baru / '\n'
	write_string ask                        ;Print string untuk meminta user menginput data
    write_string newline                    ;Print string untuk baris baru / '\n'
    write_string max_1                      ;Print string untuk note program (batas program)
	write_string newline                    ;Print string untuk baris baru / '\n'
     write_string max_2                     ;Print string untuk lanjutan note program
	write_string newline                    ;Print string untuk baris baru / '\n'
     write_string max_3                     ;Print string untuk lanjutan note program
	write_string newline                    ;Print string untuk baris baru / '\n'

input_pil:                                  ;Label input_pil
	mov ah,01h                              ;inisialisasi interupt untuk input char di terminal
	int 21h                                 ;melakujan interupt 0x21

	write_string newline                    ;Menampilkan string 
	cmp al,31h                              ;Melakukan perbandingan antara al (hasil input)dengan 31h /setara dengan
                                            ; 1 di kode ascii
	je ask_1                                ;Memerintahkan untuk melompat ke label ask_1 apabila input user adalah 31h/1
                                            ;Untuk melanjutkan proses konversi desimal ke biner

	cmp al,32h                              ;Melakukan perbandingan antara al (hasil input)dengan 32h /setara dengan
                                            ; 2 di kode ascii

	je ask_2                                 ;Memerintahkan untuk melompat ke label ask_2 apabila input user adalah 32h/2 dalam ascii
                                            ;Untuk melanjutkan proses konversi biner ke desimal

    cmp al,33h                              ;Melakukan perbandingan antara al (hasil input)dengan 33h /setara dengan
                                            ; 3 di kode ascii

    je exit                                 ;Memerintahkan untuk melompat ke label ask_2 apabila input user adalah 33h/3 dalam ascii
                                            ;Untuk melanjutkan ke label exit untuk keluar dari program

	write_string error1                     ;Print string untuk menyatakan input tidak sesuai dengan yang diinginkan atau diluar 3 pilihan
	write_string newline                    ;Print string untuk baris baru / '\n'

	jmp input_pil                           ;Kembali ke label input_pil untuk meminta user menginput ulang


;============================================================== DECIMAL -> BINARY =======================================================================================================
    
ask_1:                                      ;label ask_1 (input string untuk meminta input user bilangan decimal)
    write_string newline                    ;Print string untuk baris baru / '\n'
    write_string inputDec                   ;Print sting untuk meminta user menginput bilangan decimal untuk dikonversi

ked_1: 
 	mov ah, 01h			                    ;inisialisasi interupt untuk input char di terminal
    int 21h				                    ;melakujan interupt 0x21

	cmp al, 13   			                ;Membandingkan al (hasil input user) dengan 13 (melambangkan ENTER di kode ASCII)
    je pre_op_num_bin                       ;Memerintahkan untuk melompat ke pre_op_num_bin apabila input user adalah 13/ENTER
                                            ;Untuk melanjutkan proses konversi desimal ke biner
      
    cmp al,30h                              ;Membandingkan al (hasil input user) dengan 30h,atau angka 0 dalam kode ASCII
    jb err                                  ;Melompat ke label err apabila input user kurang dari 30h / 0
    cmp al,39h                              ;Membandingkan al (hasil input user) dengan 39h,atau angka 9 dalam kode ASCII
    ja err                                  ;Melompat ke label err apabila input user lebih dari 39h / 9

	mov ah, 0  		                        ;Menginsialisasi nilai ah (bekas inisialiasi interupt) dengan 0 agar tidak mengacaukan proses di register a 
    sub al, 48   			                ;Mengurangi nilai al dengan 48 atau -0 dalam kode ASCII

    mov cl, al 		                        ;Memindahkan nilai al ke cl 
    mov al, bl   		                    ;Memindahkan nilai yang sudah dinput sebelumnya ke al
    mov dl, 10			                    ;Memindahkan nilai 10 ke dl untuk pengkali
    mul dl       			                ;Mengalikan al dengan bl

    add al, cl   			                ;Menambahkan al dengan cl dan menyimpan nilai nya di al
    mov bl, al 			                    ;Memindahkan nilai/hasil di al ke bl

    jmp ked_1                               ;Lompat ke label ked_1 untuk mengulang input char decimal

pre_op_num_bin:                             ;Label pre_op_num_bin untuk mempersiapkan konversi
    mov ax,bx                               ;Memindahkan nilai yang ada di bx (total bilangan hasil input) ke ax
    mov bx,2                                ;Memindahka nilai 2 ke bx sebagai pembagi
    xor cx,cx                               ;Inisialisasi nilai cx dengan 0 untuk jumlah digit biner hasil konveri
   

pre_test:                                   ;Label pre_test khusus untuk kasus input user adalah 0
    cmp ax,0                                ;Membandingkan ax dengan 0
    jne logic                               ;Melompat ke label logic untuk memproses konversi selain 0
    push 0                                  ;Melakukan push nilai 0 ke stack
    inc cx                                  ;Menambahkan nilai cx untuk jumlah digit
    jmp pre_print_bin                       ;Melompat ke label pre_print_bin

logic:                                      ;Label logic untuk memproses data lebih dari 0
    xor dx,dx                               ;Inisialisasi DX dengan 0 untuk persiapan proses pembagian
    div bx                                  ;Membagi nilai ax dengan nilai di bx (2)
    cmp ax,0                                ;Membandingkan nilai ax dengan 0 (apabila bilangan decimal telah habis dibagi 2 sampai dengan 0 
                                            ;(atau nilai sebelumnya adalah 1)
    je pre                                  ;Melompat ke label pre
    cmp dx,1                                ;Membandingkan dx (sisa pembagian)dengan 1
    je ke_1                                 ;Apabila dx sama dengan 1 lompat ke label ke_1
    push 0                                  ;Push nilai 0 ke stack karena sisa pembagian yang ada di dx adalah 0/habis dibagi 2

    inc cx                                  ;Menambah nilai cx untuk total digit dari bilangan biner hasil konversi
    jmp logic                               ;Melompat kembali ke label logic untuk melakukan proses konversi kembali

ke_1:                                       ;Label ke_1 untuk push nilai 1 ke stack
    push 1                                  ;Push nilai 1 ke stack
    inc cx                                  ;Menambah nilai cx untuk total digit dari bilangan biner hasil konversi
    jmp logic                               ;Melompat kembali ke label logic untuk melakukan proses konversi kembali

pre:                                        ;Label pre untuk push nilai 1 ke stack apabila nilai ax sudah sama dengan 0
    push 1                                  ;Push nilai 1 ke stack
    inc cx                                  ;Menambah nilai cx untuk total digit dari bilangan biner hasil konversi       


pre_print_bin:                              ;Label pre_print_bin 
    write_string hasil                      ;Print string untuk menampilkan string untuk menapilkan "Hasil Konversi"
    xor dx,dx                               ;Inisialisasi DX dengan 0 untuk persiapan proses print dari nilai tiap digit biner di stack

print_bin:                                  ;Labael print_bin 
	pop dx                                  ;Mengeluarkan nilai yang ada di stack dan menyimpannya di dx
	add dl,30h                              ;Menambah nilai dl dengan 30h (dalam kode ascii bernilai 0) untuk mengkonversi bilangkan
                                            ;Ke dalam format ASCII untuk di print
	mov ah,2h                               ;Inisialisasi interupt 2h untuk fungsi output char
	int 21h                                 ;Melakukan interupt 2h
	dec cx                                  ;Mengurangi nilai CX sebagai total digit yang tersisa untuk di output di terminal

	jnz print_bin                           ;Melompat ke label print_bin apabila cx tidak sama dengan 0 atau belum semua
                                            ;digit biner di output di termnial
    write_string newline                    ;Print string untuk baris baru / '\n'

    xor ax,ax                               ;Inisisalisasi ax untuk persiapan operasi berikutnya
    xor bx,bx                               ;Inisisalisasi bx untuk persiapan operasi berikutnya
    xor cx,cx                               ;Inisisalisasi cx untuk persiapan operasi berikutnya
    xor dx,dx                               ;Inisisalisasi dx untuk persiapan operasi berikutnya
   
	jmp menu                                ;Melompat ke menu untuk melakukan perintah konversi berikutnya

;======================================================== BINARY -> DECIMAL =================================================================================================================================

ask_2:                                      ;Label ask_2 
write_string newline                        ;Print string untuk baris baru / '\n'
write_string inputBiner                     ;Print sting untuk meminta user menginput bilangan binary untuk dikonversi


ked2:                                       ;Label ked2    
    xor si,si                               ;Mempersiapkan nilai si dengan 0
    mov ax,100                              ;Mempersiapkan nilai ax dengan 100 untuk diinput di stack sebagai nilai
                                            ;'Sentinel' atau penanda proses push pada stack sudah habis
    push ax                                 ;Push nilai ax
    xor ax,ax                               ;Mengosongkan nilai ax untuk proses berikutnya (input)



input_ked2:                                 ;Label input_ked2 untuk input
    mov ah, 01h                             ;Inisialisasi interupt 01h untuk input char
    int 21h                                 ;Melakukan interupt
    cmp al,0xD                              ;Membandingkan nilai al dengan 0xD / Enter
    je pre_op_bin_num                       ;Melompat ke label pre_op_bin_num bila al sama dengan enter

    cmp al,30h                              ;Membandingkan nilai al dengan 30h atau setara dengan 0 pada ASCII
    jb err                                  ;Apabilai al kurang dari atau dibahawah 30h,maka lompat ke label err
    cmp al,31h                              ;Membandingkan nilai al dengan 31h atau setara dengan 1 pada ASCII
    ja err                                  ;Apabilai al lebih dari atau diatas 31h,maka lompat ke label err

    mov ah,0                                ;Inisialisasi nilai ah dengan 0
    sub al,30h                              ;Mengurangi nilai al dengan 30h atau setara dengan 0 pada ASCII

	push ax                                 ;Push nilai AX ke stack
    jmp input_ked2                          ;Lompat kembali ke input_ked2 untuk looping sampai user menekan enter

pre_op_bin_num:                             ;Label pre_ob_bin_num
   xor cx,cx                                ;Mengosongkan nilai cx,untuk menentukan digit keberapa yg sedang dihitung
   mov ah,0                                 ;Mengosongkan nilai ah
   mov al,0                                 ;Mengosongkan nilai al
   mov ax,1                                 ;Inisialisasi nilai ax dengan 1,sebagai proses perkalian
   mov bx,0                                 ;Mengosongkan nilai bx
   xor dx,dx                                ;Mengosongkan nilai dx
   
    
   

operasi:                                    ;Label operasi untuk proses konversi
   pop dx                                   ;Pop nilai di stack dan menyimpan di register dx
   cmp dx,100                               ;Membandingkan nilai dx dengan 100
   je pre_print_num                         ;Apanila nilai dx sama dengan 100,lompat ke label pre_print_num
   cmp dx,1                                 ;Membandingkan nilai dx dengan 1
   je hitung_pre                            ;Apabila sama dengan 1 maka lompat ke label hitung_pre
   cmp dx,0                                 ;Bandingkan dx dengan 0
   je nol                                   ;Apabila sama dengan 0,lompat ke label nol

nol:                                        ;Label nol
   inc cx                                   ;Menambah nilai cx
   jmp operasi                              ;Lompat ke label operasi

hitung_pre:                                 ;Label hitung_pre          
    cmp cx,0                                ;Membandingkan nilai cx dengan 0
    je nilai_awal                           ;Lompat ke label nilai_awal khusus penanganan  apabila digit terakhir biner
                                            ;Adalah 1

hitung:                                     ;Label hitung
    push cx                                 ;Push nilai cx ke stack untuk penyimpanan sementara dari digit ke berapa yang sedang dihitung
    mov si,2                                ;Memindahkan nilai 2 ke register si
    mul si                                  ;Mengalikan nilai ax dengan si dan menyimpan hasilnya ke ax
    dec cx                                  ;Mengurangi nilai cx
    cmp cx,0                                ;Membandingkan nilai cx dengan 0
    jne hitung                              ;Lompat kembali ke label hitung apabila tidak sama dengan 0
    add bx,ax                               ;Menambah hasil operasi perkalian 2 atau hasil pangkat dengan nilai di bx
    mov ax,1                                ;Inisialisasi nilai ax dengan 1
    xor cx,cx                               ;Mengosongkan/inisialisasi nilai cx dengan 0
    pop cx                                  ;Pop nilai yang ada di stack (nilai awal cx) ke regiter cx
    inc cx                                  ;Menambah nilai cx
    jmp operasi                             ;Lompat ke label operasi



nilai_awal:                                 ;Label nilai_awal
    add bx,1                                ;Menambah nilai bx dengan 1
    inc cx                                  ;Increment nilai cx
    jmp operasi                             ;Lompat ke label operasi
    
pre_print_num:                              ;Label pre_print_num untuk persiapan print hasil konversi
    mov ax,bx                               ;Memindahkan nilai bx ke ax
    push ax                                 ;Push nilai ax ke stack
  
    write_string hasil                      ;Print string dengan isi "Hasil Konversi" ke terminal
      
   call print_dec                           ;Memanggil fungsi print_dec
   write_string newline                     ;Print string untuk ke baris baru / '\n'
   pop dx                                   ;Pop elemen sisa dari stack yang mungkin masih tersisa dari operasi konversi
   xor dx,dx                                ;Mengosongkan nilai dx untuk konversi berikutnya
   xor ax,ax                                ;Mengosongkan nilai ax untuk konversi berikutnya
   xor bx,bx                                ;Mengosongkan nilai bx untuk konversi berikutnya
   xor cx,cx                                ;Mengosongkan nilai cx untuk konversi berikutnya
   jmp menu                                 ;Melompat kembali ke label menu

;=======================================================================================================================================================

err:                                        ;Label err untuk print string input bilangan yang tidak sesuai
                                            ;Sebelum program diakhiri
    write_string newline                    ;Print string untuk ke baris baru / '\n'
    write_string error2                     ;Print string untuk menyatakan input bilangan salah dan program akan diakhiri


exit:                                       ; Label exit untuk keluar dari program  
    write_string newline                    ;Print string untuk ke baris baru / '\n'
    write_string Thank                      ;Print string untuk berterima kasih sebelum program diakhiri
	mov ah,0x4c                             ;Inisialisasi ah dengan 0x4c untuk interupt 0x21 dengan fungsi exit
	xor al,al                               ;Mengosongkan nilai al
	int 0x21                                ;Melakukan interupt 0x21

print_dec:		                            ;Label print_dec		    
    	push bp				                ;Menyimpan bp yang lama/sebelumnya
    	mov bp, sp			                ;pointer bp menunjuk ke puncak stacl
    	mov eax, [bp + 4]		            ;Mengalokasi lokal variabel
    	mov ebx, 10			                ;Inisialisasi untuk proses pembagi 
    	mov ecx, 0x0			            ;Inisialisasi untuk menghitung jumlah digit

div_by_ten:	                                ;Label div_by_tem (membagi semua digit dengan 10 dan mengambil sisanya)			
    	xor edx, edx	                    ;Mengosongkan dx		
    	div ebx				                ;Membagi 10,sisa akan ada di dx
    	push edx		                    ;Push sisa ke stack
    	inc ecx				                ;Increment ecx untuk jumlah digit
    	cmp eax, 0x0			            ;Membandingkan nilai ax dengan 0,jika angka sudah habis berarti ax=0
    	jne div_by_ten                      ;Jika masih ada angka (eax blum 0) lompat kembali ke label div_by_ten	



print:					                    ;Label print
    	pop edx				                ;Pop isi stack dan simpan ke register edx
    	add dl, '0'			                ;Mengubah nilai dari stack menjadi nilai ASCII agar karakter yang ditampilkan sesuai dengan nilai dalam stack
    	mov ah, 0x2			                ;Inisiaslisai ah dengan 0x2 untuk inisialisasi interput untuk cetak karakter 
    	int 0x21			                ;Melakukan interupt 0x21
    	dec ecx				                ;Mengurangi nilai ecx
    	jnz print			                ;Lompat ke label print apabila nilai ecx tidak sama dengan 0
    	leave				                ;Menghapus local variables dan ambil ebp lama dari stack
    	ret				                    ;return/kembali dari fungsi

section .data                                                                                   ;Section untuk menyimpan data

pembukaan : db  "---- Decimal <-> Binary----- $",                                               ;Label pembukaan berisi string
pil1 : db  "1.Decimal Ke binary $",                                                             ;Label pil1 berisi string                                                                              ;Label tes berisi string
pil2 : db  "2.Binary Ke decimal $",                                                             ;Label pil2 berisi string 
pil3 : db  "3.Keluar program $",                                                                ;Label pil3 berisi string 
Thank : db  "---Terima Kasih telah menggunakan Program--- $",                                   ;Label Thank berisi string 
hasil : db  "Hasil Konversi : $",                                                               ;Label hasil berisi string 
input : db  " Input salah $",                                                                   ;Label input berisi string 
ask : db  "Operasi apa yang ingin dilakukan ? $",                                               ;Label ask berisi string 
error1 : db  "Bukan termasuk pilihan ! $",                                                      ;Label error1 berisi string 
error2 : db  "Input tidak sesuai program dihentikan $",                                         ;Label error2 berisi string 
max_1 : db  "Note:Untuk input decimal maximal bernilai 255 $",                                  ;Label max_1 berisi string 
max_2: db "untuk input biner maximal 16 digit $",                                               ;Label max_2 berisi string 
max_3: db "jika lebih konversi tidak sesuai! $",                                                ;Label max_3 berisi string 
inputDec: db "Masukkan bilangan desimal yang ingin di konversi  ... $",                         ;Label inputDec berisi string 
inputBiner: db "Masukkan bilangan biner yang ingin di konversi ... $",                          ;Label inputBiner berisi string 
keda1 : db  "--Decimal->binary-- $",                                                            ;Label keda1 berisi string 
keda2 : db  "--Decimal<-binary-- $",                                                            ;Label keda2 berisi string 
newline:    db 0xD,0xA,"$"                                                                      ;Label newline berisi string 