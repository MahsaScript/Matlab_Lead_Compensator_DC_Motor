%% Program to design the Lead compensator for a DC motor



close all
clear all
clc
 
%% Uncompensated control system transfer function (assuming H(s)=1)

 
%% Transfer function of DC Motor with angular displacement
% as output and armature voltage (V) as input
num=[61.07 0 40126];
den=[1 34.69 1251.6 22795.3 0];
G=tf(num,den);          
% DC Motor Parameters
R=0.5;                  % Armature Resistance (ohm)
L=0.2;                  % Armature inductance (H)
Kt=0.929;               % Torque Constant (Nm/Amp)
Kb=0.929;               % Back emf Constant (V.s/rad)
J=3;                    % Moment of inertia (kg.m^2)
b=0.0408;               % Friction Constant (Nm.s/rad)
V=200;                  % Armature voltage (V)
%% Bode plot of the uncompensated system 
figure(1)
bode(G), grid on            % To check PM and GM
title('Bode plot of uncompensated system')
[Gm,Pm,Wcg,Wcp] = margin(G); 

%% Lead compensator Design
Pmd=70;                       % Desired Phase Margin (PM)
Phi_m=Pmd-Pm+30;              % Maximum phase lead angle (dgree)
% Check diffrent values for the safety factor to get the desired PM

Phi_mr=Phi_m*(pi/180);        % Maximum phase lead angle (radian)

% Determine the transfer function of lead compensator 
alpha=(1+sin(Phi_mr))/(1-sin(Phi_mr));
Mc=-10*log10(alpha);          % Magnitude to be compensated in db

% Locate the frequecy on the Figure(1) for Mc and take it as wm
wm=1.27;
p=wm*sqrt(alpha);             % Pole of lead compensator
z=p/alpha;                    % Zero of lead compensator
gain=alpha;
numc=[1 z];
denc=[1 p];
Gc=tf(numc,denc);

% Total forward transfer function of compensated system
Gt=gain*Gc*G;

%% Comparison of compensated and uncompensated bode plots
figure(4)
bode(G,'--r', Gt,'-'), grid on
legend('Uncompensated system', 'Compensated system')
title('Comparison of compensated and uncompensated bode plots')

%% Since H(s)=1, the feedback transfer function 
Gc1u=feedback(G,1);         % Closed loop TF of uncompensated system
Gclc=feedback(Gt,1);        % Closed loop TF of compensated system
 
% Comparison of compensated and uncompensated step responses
figure(2)
step(Gc1u, '--r', Gclc, '-'); grid on  
legend('Uncompensated system' , 'Compensated system')
title('Comparison of compensated and uncompensated step responses')