clear; close all; clc;
y =[];
i = 0;

for t = 0:0.01:5
    
    i = i + 1;
    
    if t <= 3
        
        y(1,i) = 1;
        
    elseif t>3 && t<4
        
        y(1,i) = -1*(t-3)+1;
        
    else
        
        y(1,i) = 0;
        
    end
    
end
t = 0 : 0.01 : 5 ;
plot(t,y)