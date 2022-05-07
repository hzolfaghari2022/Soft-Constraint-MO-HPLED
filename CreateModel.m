function model=CreateModel()

    model.f_1 = 1-0.08;
    model.f_2 = 1+0.08;
    model.Plants.Pmin=[50 20 15 10 10 12 10  10 10 10   0];
    model.Plants.Pmax=[200 80 50 35 30 40 300 300  150 150  2695];
    model.Plants.Pmin2=[50 20 15 10 10 12 10  10 10 10   0]*model.f_1;
    model.Plants.Pmax2=[200 80 50 35 30 40 300 300  150 150  2695]*model.f_2;
    model.Plants.a=[0 0 0 0 0 0];
    model.Plants.b=[2 1.75 1 3.25 3 3];
    model.Plants.c=[0.00375 0.1750 0.06250 0.00834 0.00325 0.00325];
    model.Plants.PminActual =model.Plants.Pmin2;
    model.Plants.PmaxActual =model.Plants.Pmax2;
    model.cons =  model.f_2 - model.f_1;
 
    
    model.nPlant=numel(model.Plants.Pmin);
    
     model.PD=400;  % MW
     model.HD=115;  % MW

end