.data
  n: .space 4
  m: .space 4
  p: .space 4
  k: .space 4
  x: .space 4
  pointer_in: .space 4
  pointer_out: .space 4
  n_nou: .space 4
  m_nou: .space 4
  newMatrix: .space 1600
  lineIndex: .space 4
  columnIndex: .space 4
  matrix: .space 1296
  celula_linie: .space 4
  celula_coloana: .space 4
  index_k: .space 4
  nr: .space 4
  lineIndex_copie: .space 4
  columnIndex_copie: .space 4
  formatscanf: .asciz "%d"
  formatprintf: .asciz "%d "
  newLine: .asciz "\n"
  sir1: .asciz "Matricea citita este:\n"
  sir2: .asciz "Matricea bordata este:\n"
  sir3: .asciz "Matricea dupa k-evolutii este:\n"
  file_out: .asciz "out.txt"
  afisare_out: .asciz "w"
  format_string: .asciz "%s\n"
  citire_in: .asciz "r"
  file_in: .asciz "in.txt" 
  
.text

.global main

main:
//deschid fisierul "in.txt" din care citesc
  push $citire_in
  push $file_in
  call fopen
  add $8,%esp
  
  mov %eax,pointer_in

//citesc n,m,p din fisier si creez dimensiunile pentru matricea bordata
  pushl $m
  pushl $formatscanf
  push pointer_in
  call fscanf
  popl %ebx
  popl %ebx
  popl %ebx
  
  pushl $n
  pushl $formatscanf
  push pointer_in
  call fscanf
  popl %ebx
  popl %ebx
  popl %ebx
  
  pushl $p
  pushl $formatscanf
  push pointer_in
  call fscanf
  popl %ebx
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
  
  
//citesc celulele din fisier 
citire_celule: 
   cmpl %ecx,p
   je citire_k
   
   pushl %ecx
   pushl $celula_linie
   pushl $formatscanf
   push pointer_in
   call fscanf
   popl %ebx
   popl %ebx
   popl %ebx
   popl %ecx
   
   pushl %ecx
   pushl $celula_coloana
   pushl $formatscanf
   push pointer_in
   call fscanf
   popl %ebx
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

//citesc k din fisier 
citire_k:
   pushl $k
   pushl $formatscanf
   push pointer_in
   call fscanf
   popl %ebx
   popl %ebx
   popl %ebx
   

//inchid fisierul "in.txt"  
   push pointer_in
   call fclose
   add $4,%esp
  

//parcurg k-evolutii  
parcurgere_k:
  incl index_k
  for_k:
    movl k,%eax
    cmpl %eax,index_k
    je et_linie_noua_4
  
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
	            
	            
et_linie_noua_4:
  movl $4,%eax
  movl $1,%ebx
  movl $newLine,%ecx
  movl $2,%edx
  int $0x80
  
  jmp afisare_finala	            


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
  

//se afiseaza matricea cautata in fisierul "out.txt" 
afisare_finala:
 
//deschid fisierul "out.txt" 
  push $afisare_out
  push $file_out
  call fopen
  addl $8,%esp
          
  mov %eax,pointer_out
   
   movl $-1,lineIndex
   
   for_linii_afisare_finala:
          
     incl lineIndex
     movl $0,columnIndex
     movl m,%eax
     cmpl %eax,lineIndex
     je exit_fisier
        for_coloane_afisare_finala:
          movl n,%ebx
          cmpl %ebx,columnIndex
          je et_linie_noua_5
          
          movl $0,%edx
          movl lineIndex,%eax
          mull n
          addl columnIndex,%eax
          
          movl (%edi,%eax,4),%edx   
          
          //scriu elementele matricei in "out.txt"
          mov %edx,%eax
          push %eax
          push $formatprintf
          push pointer_out
          call fprintf
          addl $12,%esp
        
          
          
          incl columnIndex
          jmp for_coloane_afisare_finala
          
et_linie_noua_5:
 
//cobor pe urmatoarea linie in fisier 
  push $newLine
  push pointer_out
  call fprintf
  addl $8,%esp
  
  

  jmp for_linii_afisare_finala
  
exit_fisier:

//inchid fisierul "out.txt"
 push pointer_out
 call fclose
 add $4,%esp
  
 
et_exit:
  pushl $0
  call fflush
  addl $4,%esp
  
  movl $1,%eax
  movl $0,%ebx
  int $0x80
   
   
   
     
       

