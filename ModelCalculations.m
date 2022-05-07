function out=ModelCalculations(px,model)
   
    P=px(1:6);      % Plant Power
    o1=px(7);       % Electric Power CHP1
    o2=px(8);       % Electric Power CHP2
    H1=px(9);       % thermal CHP1
    H2=px(10);      % thermal CHP2
    T1=px(11);      % thermal
    
    Pmin=[50 20 15 10 10 12 10  10 10 10   0];
    Pmax=[200 80 50 35 30 40 300 300  150 150  2695];
    
    a=model.Plants.a;
    b=model.Plants.b;
    c=model.Plants.c;
    %% Costs
    
    FC=c+b.*P+a.*P.*P;           % Plant fuel Cost, P based on MW
    C_CHP1=2650+14.5*o1+0.0345*o1^2+4.2*H1+0.03*H1^2+0.031*H1*o1;
    C_CHP2=1250+36*o2+0.0435*o2^2+0.6*H2+0.027*H2^2+0.011*o2*H2;
    
    
    hC=23.4*T1;         % Heat Cost
    
    CTotal=sum(FC)+C_CHP1+C_CHP2+hC;        %Total Cost
    B=[ 25 20 15 15 14 49
        19 18 20 16 45 14
        15 12 10 39 16 15
        11 14 40 10 20 15
        17 35 14 12 18 20
        39 17 11 15 19 25 ]*1e-7;
    
    Ploss=P(1:6)*B*[P(1);P(2);P(3);P(4);P(5);P(6)];
    
    %% Power generation telorance 
    
    PD=model.PD+Ploss;         %unequality telorance
    PTotal=sum(P)+o1+o2;
    HD=model.HD;
    HTotal=H1+H2+T1;
    PowerBalanceViolation=abs(1-PTotal/PD);
    HeatBalanceViolation=abs(1-HTotal/HD);
    
    q1=20;
    q2=20;

    z=CTotal*(1+q1*max(PowerBalanceViolation,0.02))*(1+q2*max(HeatBalanceViolation,0.02))*sqrt(3);

    f1 = 18000;
    f2 = 19800;

   if z<f1
       mu0=1;
   elseif z>f1 && z<f2
       mu0=(f2-z)/(f2-f1);
   elseif z>19800
       mu0=(f2-z)/1e8;
   end

    mu=ones(1,11);
    
        
    for i=1:11
      if px(i)<Pmin(i)
          mu(i)=1-((Pmin(i)-px(i))/model.cons/Pmin(i));
      elseif px(i)>Pmax(i)
          mu(i)=1-((px(i)-Pmax(i))/model.cons/Pmax(i));
      end
    end
  
    out.mus=[mu0 , mu];
    out.P=[P o1 o2];
    out.Ploss=Ploss;
    out.H=[H1 H2 T1];
    out.PTotal=PTotal;
    out.HTotal=HTotal;
    out.Costs=[sum(FC) C_CHP1 C_CHP2  hC];        % fossil Fuel Cost
    out.CTotoal=CTotal*sqrt(2);
    out.PowerBalanceViolation=PowerBalanceViolation;
    out.HeatBalanceViolation=HeatBalanceViolation;
    out.z=min([mu0,mu]);

end