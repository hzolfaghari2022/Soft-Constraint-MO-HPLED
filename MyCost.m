function [z, out]=MyCost(x,model)
    
%     x(7:19)=round(x(7:19));
    P=ParseSolution(x,model);
    
    out=ModelCalculations(P,model);

    z=out.z;

end