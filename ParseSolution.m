function P=ParseSolution(x,model)

    PminActual=model.Plants.PminActual;
    PmaxActual=model.Plants.PmaxActual;    
    P(1:11)=PminActual+(PmaxActual-PminActual).*x(1:11);  % Plant Power :MW
    
end