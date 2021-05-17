; automation envelopes

M_noise_wave: macro
Start_of_M_noise_wave:
    dc.w    (End_of_M_noise_wave-Start_of_M_noise_wave)

counter = 0
    do
    dc.b   counter
counter = (counter+1)    
    until (counter=10)
    
    do
    rept 50
    dc.b    counter
    endr
    
counter = (counter-1)
    until (counter<0)
    
End_of_M_noise_wave:
    endm
    
E_noise_wave:
    M_noise_wave
    even