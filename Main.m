clc;
clear;
close all;

tic
%% Problem Definition
% x1_x6     Fossil fuel
% x7_x8     CHP Electric power O1 O2
% X9_x10    CHP Termal Power  H1 H2
% x11       Termal
model=CreateModel();

CostFunction=@(x) MyCost(x,model);        % Cost Function

nVar=11;             % Number of Decision Variables

VarSize=[1 11];   % Size of Decision Variables Matrix

VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables


%% PSO Parameters

MaxIt=300;      % Maximum Number of Iterations

nPop=1500;        % Population Size (Swarm Size)

 w=1;
 c1=2;           % Personal Learning Coefficient
 c2=2;           % Global Learning Coefficient


% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Out=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Out=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Cost=-1;

for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost, particle(i).Out]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Out=particle(i).Out;
    
    % Update Global Best
    if particle(i).Best.Cost>BestSol.Cost
        
        BestSol=particle(i).Best;
        
    end
    
end

BestCost=zeros(MaxIt,1);


%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        [particle(i).Cost, particle(i).Out] = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost>particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Out=particle(i).Out;
            
            % Update Global Best
            if particle(i).Best.Cost>BestSol.Cost
                
                BestSol=particle(i).Best;
                
            end
            
        end
        
    end
    
    BestCost(it)=BestSol.Cost;
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    w=0.9-0.7*(it/MaxIt);
    
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');


disp( ' ')
disp('     ==RESULTS==    ')

disp( ' ')
disp(['  Max(min(mu0...11)) = =' num2str(min(BestSol.Out.mus))])

disp( ' ')
disp(['  PowerViolation(%) = =' num2str(BestSol.Out.PowerBalanceViolation*100)])

disp( ' ')
disp(['  HeatViolation(%) = =' num2str(BestSol.Out.HeatBalanceViolation*100)])

disp( ' ')
disp(['  mu[0...11] = =' num2str(BestSol.Out.mus)])

disp( ' ')
disp(['  P[0...6] = =' num2str(round(BestSol.Out.P(1:6)))])
filename = 'p1_p6.xlsx';
xlswrite(filename,BestSol.Out.P(1:6))

disp( ' ')
disp(['  Chp[1,2] Electric Power = =' num2str(BestSol.Out.P(7:8))])

disp( ' ')
disp(['  Chp[1,2] heat Power = =' num2str(BestSol.Out.H(1:2))])

disp( ' ')
disp(['  Termal Unit Power = =' num2str(BestSol.Out.H(3))])

disp( ' ')
disp(['  Total Cost = =' num2str(BestSol.Out.CTotoal)])

toc;

disp( ' ')
disp(['  Total Time = =' num2str(toc)])