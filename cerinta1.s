.data
  n: .space 4
  m: .space 4
  p: .space 4
  k: .space 4
  o: .space 4
  y: .space 4
  x: .space 4
  nr2: .space 4
  nr_elemente: .space 4
  cifra: .space 4
  suma: .space 4
  contor: .space 4
  vector_criptare: .space 400
  vector_decriptare: .space 400
  vector_hexa: .space 400
  copie: .space 4
  n_nou: .space 4
  m_nou: .space 4
  newMatrix: .space 1600
  sir_biti: .space 1600
  lineIndex: .space 4
  columnIndex: .space 4
  matrix: .space 1296
  celula_linie: .space 4
  celula_coloana: .space 4
  index_k: .space 4
  nr: .space 4
  litera: .space 4
  lineIndex_copie: .space 4
  columnIndex_copie: .space 4
  mesaj_criptare_decriptare: .space 20
  formatscanf: .asciz "%d"
  formatprintf: .asciz "%d "
  formatprintf2: .asciz "%d\n" 
  formatprintf3: .asciz "%d"
  formatprintf4: .asciz "%s"
  newLine: .asciz "\n"
  format_string: .asciz "%s\n"
  format_caracter: .asciz "%c"
  sir1: .asciz "Matricea citita este:\n"
  sir2: .asciz "Matricea bordata este:\n"
  sir3: .asciz "Matricea dupa k-evolutii este:\n"
  sir4: .asciz "Sirurile de biti cheie, mesaj si cript sunt:\n"
  sir5: .asciz "Sirul de biti al mesajului este:\n"
  sir6: .asciz "0x"
  sir7: .asciz "Sirul criptat este:\n"
  
.text

.global main

main:

//citesc n,m,p de la tastatura si creez dimensiunile pentru matricea bordata
  pushl $m
  pushl $formatscanf
  call scanf
  popl %ebx
  popl %ebx
  
  pushl $n
  pushl $formatscanf
  call scanf
  popl %ebx
  popl %ebx
  
  pushl $p
  pushl $formatscanf
  call scanf
  popl %ebx
  popl %ebx

  movl n,%eax
  movl m,%ebx
  addl $2,%eax
  addl $2,%ebx
  movl %eax,n_nou
  movl %ebx,m_nou
  
  lea matrix,%edi
  lea newMatrix,%esi
  xorl %ecx,%ecx
  movl $-1,index_k
  
//citesc celulele de la tastatura  
citire_celule: 
   cmpl %ecx,p
   je citire_k_o
   
   pushl %ecx
   pushl $celula_linie
   pushl $formatscanf
   call scanf
   popl %ebx
   popl %ebx
   popl %ecx
   
   pushl %ecx
   pushl $celula_coloana
   pushl $formatscanf
   call scanf
   popl %ebx
   popl %ebx
   popl %ecx
   

//formez matricea nebordata   
   movl celula_linie,%eax
   mull n
   addl celula_coloana,%eax
   
   movl $1,(%edi,%eax,4)
   
//formez matricea bordata  
   incl celula_linie
   incl celula_coloana
   movl celula_linie,%eax
   mull n_nou
   addl celula_coloana,%eax
   
   movl $1,(%esi,%eax,4)
   
   incl %ecx
   jmp citire_celule

//citesc k, o si mesajul de la tastatura  
citire_k_o:
   pushl $k
   pushl $formatscanf
   call scanf
   popl %ebx
   popl %ebx
   
   pushl $o
   pushl $formatscanf
   call scanf
   popl %ebx
   popl %ebx
   
   push $mesaj_criptare_decriptare
   push $format_string
   call scanf
   pop %ebx
   pop %ebx

//parcurg k-evolutii  
parcurgere_k:
  incl index_k
  for_k:
    movl k,%eax
    cmpl %eax,index_k
    je et_et
  
	  movl $-1,lineIndex
	  for_linii_parcurgere_k:
	    movl m,%eax
	    movl $0,columnIndex
	    incl lineIndex
	    cmpl %eax,lineIndex
	    je actualizare_matrice_bordata
	    
		  for_coloane_parcurgere_k:
		    movl n,%ebx
		    movl $0,nr
	            cmpl %ebx,columnIndex
	            je for_linii_parcurgere_k
	           
	            movl lineIndex,%eax
	            mull n
	            addl columnIndex,%eax
	            
	            movl (%edi,%eax,4),%ebx
	            cmpl $1,%ebx
	            je coordonate
	            cmpl $0,%ebx
	            je coordonate
	            incl columnIndex
	            jmp for_coloane_parcurgere_k
	           	            


//se actualizeaza matricea bordata cu noii termeni, altfel se va afisa doar matricea dupa 1-evolutie 	
actualizare_matrice_bordata:
  movl $-1,lineIndex
  for_linii_actualizare: 
    incl lineIndex
    movl m,%eax
    movl $0,columnIndex
    cmpl lineIndex,%eax
    je parcurgere_k
      
       for_coloane_actualizare:
          movl n,%ebx
          cmpl columnIndex,%ebx
          je for_linii_actualizare
          
          movl lineIndex,%eax
          mull n
          addl columnIndex,%eax
          
          movl (%edi,%eax,4),%ebx
          
          incl lineIndex
          incl columnIndex
          
          movl lineIndex,%eax
          mull n_nou
          addl columnIndex,%eax
          
          movl %ebx,(%esi,%eax,4)
          
          decl lineIndex
          
          jmp for_coloane_actualizare
          
              
//coordonatele punctului in matricea bordata	           
coordonate:
  movl lineIndex,%eax
  movl %eax,lineIndex_copie
  movl columnIndex,%eax
  movl %eax,columnIndex_copie
  
  incl lineIndex
  incl columnIndex
  jmp coordonate_sus


//vecinul de sus
coordonate_sus: 
  decl lineIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_sus
  jmp coordonate_stanga_sus
  
  
//vecinul din stanga sus
coordonate_stanga_sus:
  decl columnIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_stanga_sus
  jmp coordonate_stanga
  
  
//vecinul din stanga
coordonate_stanga:
  incl lineIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_stanga
  jmp coordonate_stanga_jos


//vecinul din stanga jos  
coordonate_stanga_jos:
  incl lineIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_stanga_jos
  jmp coordonate_jos
  
  
//vecinul de jos  
coordonate_jos:
  incl columnIndex
  movl $0,%edx

  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_jos
  jmp coordonate_dreapta_jos
  
  
//vecinul din dreapta jos  
coordonate_dreapta_jos:
  incl columnIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_dreapta_jos
  jmp coordonate_dreapta
  
  
//vecinul din dreapta  
coordonate_dreapta:
  decl lineIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_dreapta
  jmp coordonate_dreapta_sus
  
  
//vecinul din dreapta sus  
coordonate_dreapta_sus:
  decl lineIndex
  movl $0,%edx
  
  movl lineIndex,%eax
  mull n_nou
  addl columnIndex,%eax
  movl (%esi,%eax,4),%edx
  cmpl $1,%edx
  je nr_dreapta_sus
  cmpl $1,%ebx
  je reguli_1
  jmp reguli_2


//se numara vecinii nenuli   
nr_sus:
  incl nr
  jmp coordonate_stanga_sus
  
nr_stanga_sus:
  incl nr
  jmp coordonate_stanga
  
nr_stanga:
  incl nr
  jmp coordonate_stanga_jos
  
nr_stanga_jos:
  incl nr
  jmp coordonate_jos
  
nr_jos:
  incl nr
  jmp coordonate_dreapta_jos
  
nr_dreapta_jos:
  incl nr
  jmp coordonate_dreapta
  
nr_dreapta:
  incl nr
  jmp coordonate_dreapta_sus
  
nr_dreapta_sus:
  incl nr
  cmpl $1,%ebx
  je reguli_1
  jmp reguli_2


//regulile pentru termenii egali cu 1  
reguli_1:
  movl nr,%eax
  cmpl $2,%eax
  jl et_subpopulare
  
  cmpl $2,%eax
  je et_continuitate
  
  cmpl $3,%eax
  je et_continuitate
  
  cmpl $3,%eax
  jg et_ultrapopulare
  
et_subpopulare:
  movl $0,%edx
  movl lineIndex_copie,%eax
  mull n
  addl columnIndex_copie,%eax
  
  movl $0,(%edi,%eax,4)
  
  movl lineIndex_copie,%eax
  movl %eax,lineIndex
  movl columnIndex_copie,%eax
  movl %eax,columnIndex
  
  incl columnIndex
  jmp for_coloane_parcurgere_k
  
et_continuitate:
  movl $0,%edx
  movl lineIndex_copie,%eax
  mull n
  addl columnIndex_copie,%eax
  
  movl $1,(%edi,%eax,4)
  
  movl lineIndex_copie,%eax
  movl %eax,lineIndex
  movl columnIndex_copie,%eax
  movl %eax,columnIndex
  
  incl columnIndex
  jmp for_coloane_parcurgere_k
  
et_ultrapopulare:
  movl $0,%edx
  movl lineIndex_copie,%eax
  mull n
  addl columnIndex_copie,%eax
  
  movl $0,(%edi,%eax,4)
  
  movl lineIndex_copie,%eax
  movl %eax,lineIndex
  movl columnIndex_copie,%eax
  movl %eax,columnIndex
  
  incl columnIndex
  jmp for_coloane_parcurgere_k
 
 
//regulile pentru termenii egali cu 0 
reguli_2:
  movl nr,%eax
  cmpl $3,%eax
  je et_creare
  
  movl lineIndex_copie,%eax
  movl %eax,lineIndex
  movl columnIndex_copie,%eax
  movl %eax,columnIndex
  incl columnIndex
  jmp for_coloane_parcurgere_k
  
et_creare:
  movl $0,%edx
  movl lineIndex_copie,%eax
  mull n
  addl columnIndex_copie,%eax
  
  movl $1,(%edi,%eax,4)
  
  movl lineIndex_copie,%eax
  movl %eax,lineIndex
  movl columnIndex_copie,%eax
  movl %eax,columnIndex
  
  incl columnIndex
  jmp for_coloane_parcurgere_k

  
  


et_et:  
  lea sir_biti,%edi
  xorl %ecx,%ecx

array_cheie:
//formam array-ul de biti din elementele matricei 
formare_array_biti:
  movl $-1,lineIndex
  for_linii_array_biti:
     movl m_nou,%eax
     incl lineIndex
     movl $0,columnIndex
     cmpl lineIndex,%eax
     je criptare_decriptare
        
        for_coloane_array_biti:
           movl n_nou,%ebx
           cmpl columnIndex,%ebx
           je for_linii_array_biti
           
           movl lineIndex,%eax
           mull n_nou
           addl columnIndex,%eax
           
           movl (%esi,%eax,4),%ebx
           movl %ebx,(%edi,%ecx,4)
           
           incl %ecx
           incl columnIndex
           jmp for_coloane_array_biti
           
           

  
//decidem daca vom cripta sau vom decripta
criptare_decriptare:
  movl m_nou,%eax
  mull n_nou
  movl %eax,x

  movl o,%eax
  cmpl $0,%eax
  je et_criptare
  jmp et_decriptare
  

//o=0, astfel mesajul va fi criptat  
et_criptare:  
  lea mesaj_criptare_decriptare,%esi
  movl $-1,%ecx
  movl x,%ebx
  decl %ebx
  movl %ebx,y
  movl $-1,nr


 
//transformam fiecare litera din mesaj in codul ascii corespunzator, apoi ii facem reprezentarea in binar    
      for_litere_cuvant:
        incl %ecx
        incl nr
        movb (%esi,%ecx,1),%ah
        cmpb $0,%ah
        je nr_array_biti
        
           mov %ah,litera
           movzx litera,%edx
           
           movl y,%ebx
           addl $8,%ebx
           movl %ebx,%eax
           subl $7,%eax
           movl %ebx,y
           
           scriere_biti:
             
              cmpl %eax,%ebx
              je for_litere_cuvant
              
                movl %edx,copie
                and $1,%edx
                jz et_adauga_0
                jmp et_adauga_1
                
et_adauga_0:
  movl copie,%edx
  decl %ebx
  shr $1,%edx
  jmp scriere_biti
  
et_adauga_1:
  movl copie,%edx
  movl $1,(%edi,%ebx,4)
  decl %ebx
  shr $1,%edx
  jmp scriere_biti
  
nr_array_biti:

  movl $8,%eax
  mull nr
  movl %eax,nr
  
  addl x,%eax
  movl x,%ecx
 
 
 
//comparam lungimea cheii cu lungimea mesajului  

  lea vector_criptare,%esi
  movl nr,%eax
  movl x,%ebx
  cmpl %eax,%ebx
  jl et_xor_1
  jmp et_xor_2


//mesajul are lungimea mai mare  
et_xor_1:
  movl nr,%eax
  movl %eax,nr_elemente
  movl x,%ecx
  add %ecx,%eax
  movl %eax,contor
  movl $0,%eax
  movl $0,nr2
  
  
     xor_1:
       movl %eax,copie
       cmpl contor,%ecx
       je et_linie_noua_9_1
       
       cmpl x,%eax
       je resetare_1
       
    
       movl (%edi,%eax,4),%ebx
       movl (%edi,%ecx,4),%edx
       xorl %ebx,%edx
       
       movl nr2,%eax
       movl %edx,(%esi,%eax,4)
       movl copie,%eax
       
       incl nr2
       incl %eax
       incl %ecx
       jmp xor_1
       
resetare_1:
  movl $0,%eax
  jmp xor_1
  



//cheia are lungimea mai mare decat mesajul sau sunt de lungimi egale
et_xor_2:
  
  movl nr,%eax
  movl %eax,nr_elemente
  movl x,%ecx
  movl %ecx,nr2
  add %ecx,%eax
  movl %eax,contor
  movl $0,%eax
  
    
     xor_2:
       movl %ecx,copie
       cmpl contor,%ecx
       je et_linie_noua_9_2
       
       movl (%edi,%eax,4),%ebx
       movl (%edi,%ecx,4),%edx
       xorl %ebx,%edx
       
       movl %edx,(%esi,%ecx,4)
       movl copie,%ecx
       
       incl %eax
       incl %ecx
       jmp xor_2
  

       
et_linie_noua_9_1:
  
  
  xorl %edx,%edx
  movl nr_elemente,%eax
  movl $4,%ebx
  divl %ebx
  movl %eax,nr_elemente
  
  movl $0,%ecx
  movl $0,%ebx
  jmp criptare_hexa
  

et_linie_noua_9_2:
  xorl %edx,%edx
  movl nr_elemente,%eax
  movl $4,%ebx
  divl %ebx
  movl %eax,nr_elemente
  
  movl x,%ecx
  movl $0,%ebx
  

//facem trecerea de la baza 2 la hexa
criptare_hexa:
  
  movl $0,suma
  
  cmpl nr_elemente,%ebx
  je transformare_litere
  
  
  movl (%esi,%ecx,4),%eax
  movl $8,%edx
  mull %edx
  add suma,%eax
  movl %eax,suma
  
  incl %ecx
  movl (%esi,%ecx,4),%eax
  movl $4,%edx
  mull %edx
  add suma,%eax
  movl %eax,suma
  
  incl %ecx
  movl (%esi,%ecx,4),%eax
  movl $2,%edx
  mull %edx
  add suma,%eax
  movl %eax,suma
  
  incl %ecx
  movl (%esi,%ecx,4),%eax
  movl $1,%edx
  mull %edx
  add suma,%eax
  movl %eax,suma
  
  movl suma,%edx
  movl %edx,(%edi,%ebx,4)
  
  incl %ecx
  incl %ebx
  jmp criptare_hexa
  

//facem conversia numerelor de 2 cifre la literele corespunzatoare si afisam mesajul criptat in hexa       
transformare_litere:

  movl $4,%eax
  movl $1,%ebx
  movl $sir6,%ecx
  movl $3,%edx
  int $0x80

  movl $0,%ecx 
  
  for_transformare_litere:
    cmpl nr_elemente,%ecx
    je et_linie_noua_10
    
    movl (%edi,%ecx,4),%edx
    
    cmpl $10,%edx
    je et_A
    
    cmpl $11,%edx
    je et_B
    
    cmpl $12,%edx
    je et_C
    
    cmpl $13,%edx
    je et_D
    
    cmpl $14,%edx
    je et_E
    
    cmpl $15,%edx
    je et_F
    
    pushl %ecx
    pushl %edx
    pushl $formatprintf3
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
    
et_A:
  movb $'A',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
    
et_B:
  movb $'B',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
    
et_C:
  movb $'C',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
  
et_D:
  movb $'D',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
    
et_E:
  movb $'E',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
    
et_F:
  movb $'F',%al
  movb %al,litera
  
    pushl %ecx
    pushl $litera
    pushl $formatprintf4
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    
    pushl %ecx
    pushl $0
    call fflush
    popl %ebx
    popl %ecx
    
    incl %ecx
    jmp for_transformare_litere
  
    
et_linie_noua_10:
  movl $4,%eax
  movl $1,%ebx
  movl $newLine,%ecx
  movl $2,%edx    
  int $0x80
  jmp et_exit
  

  



//o=1, astfel mesajul va fi decriptat
et_decriptare:
  
  lea mesaj_criptare_decriptare,%esi
  movl x,%ecx
  movl $1,nr
  movl $1,%eax
  decl %ecx
  movl %ecx,y
  
    for_extragere_caractere:
       incl nr
       movl nr,%eax
       movb (%esi,%eax,1),%bh
       cmpb $0,%bh
       je et_comparare_lungimi_decriptare
       
       movb %bh,litera
       mov litera ,%edx
       sub $'0',%edx
      
       cmp $9,%edx
       jle et_adauga_cifra
       
       cmp $17,%edx
       je et_transformare_A
       
       cmp $18,%edx
       je et_transformare_B 
       
       cmp $19,%edx
       je et_transformare_C      
  
       cmp $20,%edx
       je et_transformare_D
       
       cmp $21,%edx
       je et_transformare_E
       
       cmp $22,%edx
       je et_transformare_F 
       
      
       
       
et_adauga_cifra:
  
  movl y,%ecx
  movl %ecx,%eax
  addl $4,%ecx
  movl %ecx,y
  
  for_et_adauga_cifra:
     movl %edx,copie
     cmpl %eax,%ecx
     je for_extragere_caractere
     
     and $1,%edx
     cmpl $1,%edx
     je et_bit_1
     jmp et_bit_0
     
  et_bit_1:
    movl copie,%edx
    movl $1,(%edi,%ecx,4)
    shr $1,%edx
    decl %ecx
    jmp for_et_adauga_cifra
    
  et_bit_0:
    movl copie,%edx
    shr $1,%edx
    decl %ecx
    jmp for_et_adauga_cifra
    
    
et_transformare_A:
  movl $10,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  
et_transformare_B:
  movl $11,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  
  
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  
et_transformare_C:
  movl $12,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  
  decl %ecx
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  
et_transformare_D:
  movl $13,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  
  movl $1,(%edi,%ecx,4)
  decl %ecx
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  
et_transformare_E:
  movl $14,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  

  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  
et_transformare_F:
  movl $15,%edx
  movl y,%ecx
  addl $4,%ecx
  movl %ecx,y
  
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  decl %ecx
  movl $1,(%edi,%ecx,4)
  
  jmp for_extragere_caractere
  

et_comparare_lungimi_decriptare:

  movl y,%eax
  movl y,%ebx
  subl x,%eax
  incl %eax
  movl %eax,y
  lea vector_decriptare,%esi
  cmpl x,%eax
  jg et_cript_mai_mare
  jmp et_cript_mai_mic_sau_egal
  
  
et_cript_mai_mare:
  movl $0,%eax
  movl x,%ecx
  movl %ebx,y
  incl y
  movl $-1,nr
  
  for_et_cript_mai_mare:
    
    cmpl y,%ecx
    je et_creare_mesaj_decriptat
    incl nr
    
    cmpl x,%eax
    je resetare_3
    
    movl (%edi,%eax,4),%ebx
    movl (%edi,%ecx,4),%edx
    
    xorl %ebx,%edx
    
    movl %edx,(%esi,%ecx,4) 
    
    
    incl %eax
    incl %ecx
    jmp for_et_cript_mai_mare
    
resetare_3:
  movl $0,%eax
  jmp for_et_cript_mai_mare
  
    
  
et_cript_mai_mic_sau_egal:
  movl $0,%eax
  movl x,%ecx
  movl %ebx,y
  incl y
  movl $-1,nr
  
  for_cmmsg:
    incl nr
    cmpl y,%ecx
    je et_creare_mesaj_decriptat
    
    movl (%edi,%eax,4),%ebx
    movl (%edi,%ecx,4),%edx
    
    xorl %ebx,%edx
    
    movl %edx,(%esi,%ecx,4)
    
    incl %eax
    incl %ecx
    jmp for_cmmsg
    
et_creare_mesaj_decriptat:
  lea vector_decriptare,%edi
  movl x,%ecx
  decl %ecx
  movl $0,nr2
  
    for_creare_mesaj_decriptare:
    
       movl $0,suma
       cmpl y,%ecx  
       jg etapa_finala_decriptare
       
       addl $8,%ecx
       movl %ecx,copie
       
       movl (%esi,%ecx,4),%edx
       movl $1,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $2,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $4,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $8,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $16,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $32,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $64,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl (%esi,%ecx,4),%edx
       movl $128,%eax
       mull %edx
       add suma,%eax
       movl %eax,suma
       decl %ecx
       
       movl suma,%edx
       movl nr2,%eax
       
       movl %edx,(%edi,%eax,4)
   
       
       movl copie,%ecx
       incl nr2
       jmp for_creare_mesaj_decriptare

etapa_finala_decriptare:
  movl $0,%ecx
  decl nr2
    
    for_etapa_finala_decriptare:
     cmpl nr2,%ecx
     je et_linie_noua_11
     
     movl (%edi,%ecx,4),%edx
     
     pusha
     push %edx
     push $format_caracter
     call printf
     addl $8,%esp
     popa
     
     pusha
     push $0
     call fflush
     add $4,%esp
     popa
     
     incl %ecx
     jmp for_etapa_finala_decriptare
     
et_linie_noua_11:
  movl $4,%eax
  movl $1,%ebx
  movl $newLine,%ecx
  movl $2,%edx    
  int $0x80
      
et_exit:
  pushl $0
  call fflush
  addl $4,%esp

  movl $1,%eax
  movl $0,%ebx
  int $0x80
   
   
  
