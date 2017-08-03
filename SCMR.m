%% Strongly Coupled Magnetic Resonance Calculator
%  RSD & WH
% Calculates resonant frequnecy, Q, optimal spacing, etc. for an SCMR
% helical coil.
%
% All numbered equations are in reference to paper titled:
% Optimization of Wireless Power Transfer via 
%    Magnetic Resonance in Different Media
%
% Usage: SCMR('wire'), SCMR('bigwire') -> uses default values
%
%  SCMR(rc, N)  -> uses provided cross section + turns, calculates
%        values according to ~9.52 optimal r/rc ratio
%
%  SCMR(rc, N, r) -> uses optimal pitch (will produce INF if rc or r is not large enough)
%  SCMR(rc, N, r, pitch) -> self explanitory
%  SCMR(rc, N, r, pitch, external_capacitance) -> uses exnternal capacitance 
%       to add to the capacitance of the coil (thus lowering the resonant frequency)
%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$
function [geom, L,C,Ctot,f0,Gamma,Q]=SCMR(varargin)                % Statrup
%% Physical constants
 global u0 ur c hp e0 Z0 q0 ke p sigma
 u0    = 4*pi/1E7;                                           % Permeability of free space [N/A^2]
 ur    = 1.256629*1E-6;                                      % Permeability of copper 
 c     = 2.998*1E+8;                                         % Speed of light in vacuum [m/s]
 hp     = 6.626*1E-11;                                       % Planck constant [J*s]
 e0    = 1/(u0*c^2);                                         % Permittivity of free space [F/m]
 Z0    = u0*c;                                               % Characteristic impedance of free space [Ohms] 
 q0    = 1.602*1E-19;                                        % Elementary Charge [Coulombs]
 ke    = 1/(4*pi*e0);                                        % Coulomb's constant [N*m^2/C^2]
 p     = 1.68*1E-8;                                          % Coil material resistivity (copper) [Ohms*m];
 sigma = 5.96*1E7;                                           % Material conductivity (copper) [S/m]

%% Coil Parameters for adjustment
  excap  = 0;                                                % No external capacitor or lead capacitance
 %excap = 200*1E-12;                                         % Externally attached capacitor [F]
  %% Argument Parsing
 if (nargin==0)                                              % Check for arguments
   fprintf('Using default values');                          % No argumens
   [rc,r,N,pitch]=useDefaults('wire');                       % Uses (17AWG, 1.25cm, 8 turns, 2.025*rc)
 elseif (nargin==1)                                          % Check for Correct inputs
   if (strcmp(varargin{1}, 'wire'))
    [rc,r,N,pitch]=useDefaults('wire');                      % Use defaults
   elseif strcmp(varargin{1}, 'bigwire')
    [rc,r,N,pitch]=useDefaults('bigwire');                   % Uses (4AWG, 1in, 6, 1.5cm)
   else
       printf('Only 1 argument provided, must choose correct default setting!')
   end
 elseif (nargin>=2)
     rc= varargin{1};                                         % Provided rc
     N = varargin{2};                                         % Provided N
     if nargin==3
       r = varargin{3};                  
     elseif nargin>=4                                        % If there's enough arugments
       r = varargin{3};                                      % Coil radius = argument 3
       pitch = varargin{4};                                  % Pitch = arguent 4
       if (nargin == 5)                                      % If 5 input arguments
           excap = varargin{5};                              % Provided external capacitor value
       end
     end  
 end                                                         % End if

 %% Override r,rc,N,pitch,excap here if necessary.
 % rc = awg2m(17)
 % r  = in2m(3.25/2);
 geom = [r,N,rc,pitch]                                       % Geometric parameters in [m] for function to return
 %% Core Calculations
  L        = (u0*r*N^2)*(log(8*r/rc)-2);                     % Self Inductance of solid core copper coil [H]
  C        = queryC(pitch,rc,r);                             % Estimated capacatance for the coil geometry
  Ctot     = C + excap;                                      % Parallel capacitance added by external capacitor
  f0       = 1/(2*pi*sqrt(L*Ctot));                          % Estimated Real Resonant frequency 
  w        = 2*pi*f0;                                        % Resonany Angular frequnecy
  lambda   = c/f0;                                           % Wavelength [m]
   
  Qmax     = QGlobal_max(N, rc);                             % Calculate Q Global Maximum
  [Qm, fr] = maxQ(r,rc,N);                                   % Calculate Q local Maximum
  Ql       = QLocal_max(r,rc,N);                                                         
  [sp, Cdesired]  = cap_spacing(L,r,rc,fr);                  % "Optimal" Spacing, C is solved from fres=1/2*pi*sqrt(LC)
  k        = 2*pi/lambda;                                    % Wavenumber [rad/m]
 
  %Rz       = sqrt(u0*p*pi*fr)*N*r/rc;                       % Rohm = ohmic resistance [ohms]
  %Rr       = (pi/6)*Z0*(N^2)*(2*pi*fr*r/c)^4;               % Rrad = radiation resistance [ohms]
  l       = 2*pi*r*N;                                        % end-to-end coil length
  h       = pitch * N;                                       % Coil "height"
  Ro      = sqrt(u0*w/(2*sigma))*(l/(4*pi*rc));              % Rohm = ohmic resistance [ohms]
  Rr      = sqrt(u0/e0)*...                                  % Rrad = radiation resistance [ohms]
       ( (pi/12) * N^2 * (w*r/c)^4 + (2/(3*pi^3)) * (w*h/c)^2 );
  Gamma    = (Ro + Rr) / (2*L);                              % reverse derived from Q forlulas across papers 
  Q        = w/(2*Gamma);                                    % Q, Gamma is the loss
  
%% Sanity Checks
 if (r>=lambda/(6*pi))                                       % Check coil radius condition, page 24
     disp ('Coil Radius too big!');
 end
 
 if ((2*pi*r*N)>=lambda/3)                                   % Check coil length condition
     disp ('Coil length too large!');
 end

 if (pitch/(2*rc)>2 )                                        % Check coil helix spacing condition
     disp ('Capacitance formulation out of valid range!');
 end
 
 if (f0 <= 100E3 || f0 >= 100E6)                             % Check resonant frequency condition
     disp ('Resonant frequency may be out of range!');
 end

 %% Print & finish
 printResults(r,rc,pitch,N,L,excap,C,f0,Q,Cdesired,sp,Qmax,Qm,Ql,fr,Gamma, Ro, Rr);
                                                                        
end


%% Set coil geometry/ easy switching between 'tube' and 'wire' coils %%%%%%%%%%
function [rc,r,N,pitch] = useDefaults(coilType)
    if (strcmp('bigwire', coilType))
      rc     = awg2m(4);                                    % Coil wire cross section radius [m]  
      rc     = in2m(0.25/2);
      r      = in2m(.75);                                   % 1.25" Radius
      r      = rc*exp(13/3)/8;                              % Optimized radius in terms of Qmax
      pitch  = 0.8E-2;                                      % Copper tube coil pitch ~1cm
      N      = 5.25;                                        % Number of turns
      
    elseif (strcmp('wire', coilType))
      rc     = awg2m(22);                                   % Coil wire, cross section 22 AWG
      r      = 10E-2;                                       % diam = 3.25 in
      pitch  = 2.025*rc;                                    % distance from the center of one loop to the center of the next loop 
      N      = 10;                                          % Turns
    end
end

%% Function to calculate Q of arbitrary coil helix
function [Qeff]  = Qquery (f, r, rc, N)                     % Q formula for helix geometry (3.9)
    global c ur u0 p Z0
    u    = ur;
    Qeff = (2*pi*f*u*r*N^2)*(log(8*r/rc)-2);
    Rz    = sqrt(u0*p*pi*f)*N*r/rc;                         % Rohm = ohmic resistance [ohms]
    Rr    = (pi/6)*Z0*(N^2)*(2*pi*f*r/c)^4;                 % Rrad = radiation resistance [ohms]
    Qeff = Qeff / (Rz + Rr);
end

%% Function to calulcate optimal resonant frequency 
function fmax = maxf(r,rc,N)                                % Want f_Resonant=f_Max for maximum Q (3.10, 3.13)
    global c u0 ur p
    u    = ur;                                              % not sure if Urelative or u0
    fmax = c^(8/7)*u^(1/7)*p^(1/7);
    fmax = fmax / (4*15^(2/7)*N^(2/7)*rc^(2/7)*pi^(11/7)*r^(6/7));
end


%% Function to calculate Q local maximum.
function [Qmax,fr] = maxQ (r,rc,N)                          % Calculate Qmax (3.11) using 3.9-3.12
 fr   = maxf(r,rc,N);
 Qmax = Qquery(fr, r, rc, N);
end

%% Function to calulcate optimal coil radius given fres
function rmax = maxr(N,fr,rc) 	                            % Maximum (optimal) radius (3.14)
    global c u0 ur p
    u    = ur;                                              % not sure if Ur or u0
    rmax = (c^(8/7)*u^(1/7)*p^(1/7));
    rmax = rmax/(4*15^(2/7)*rc^(2/7)*N^(2/7)*pi^(11/7)*fr);
    rmax = rmax^(7/6);
end


%% Function to calulcate local optimal coil radius given freq
function QLmax = QLocal_max(r,rc,N)                         % Eq 3.16		
    global c u0 p
    u    = u0;                                              % not sure if Urelative or u0
    qm = 2*3^(6/7)*rc^(6/7)*c^(8/7)*N^(6/7)*p^(1/7); 
    QLmax = qm*(log(8*r/rc)-2); 
    d1    = 5^(1/5)*pi^(2/7)*r^(3/7);
    t1    = c^(4/7)*u^(4/7)*p^(4/7);
    t2    = 6*rc^(1/7)*N^(1/7)*r^(3/7);
    t3    = sqrt(c^(8/7)*u^(8/7)*p^(8/7)/(rc^(2/7)*N^(2/7)*r^(6/7)));
    QLmax = QLmax / (d1*(t1+t2*t3));

   % if (QLmax ~= maxQ(r,rc,N))
   %    disp('Qmax function is wrong somewhere. Debug');
   % end

end

%% Function to calulcate optimal coil radius given freq
function QGmax = QGlobal_max(N,rc)                          % Find Global maximum Q factor (3.18)	
    global c u0 p
    u    = u0;                                              % not sure if Urelative or u0
    QGmax  = 28*2^(2/7)* rc^(3/7) * c^(8/7) * u^(8/7) ...
	      * N^(6/7) * p^(1/7);
    d1     = (15*(1^7)*exp(13/7)*pi^(2/7));
    t1     = sqrt((c^(8/7)*u^(8/7)*p^(8/7))/(rc^(8/7)*N^(2/7)));
    d2     = c^(4/7)*u^(4/7)*p^(4/7) + 6*rc^(4/7)*N^(1/7)*t1;
    QGmax  = QGmax / (d1*d2);
end

%% Function to calculate rc max given f0, N, and t=r/rc
function  [rcmax, rmax] = maxr_maxrc(f0, N, t)              % Eq (3.19) & (3.20)
    global c u0 p
    u    = u0;                                              % not sure if Urelative or u0
    num1  = c*u^(1/8)*p^(1/8);
    num2  = 2*2^(3/4)*15^(1/4); 
    num3  = N^(1/4)*f0^(7/8)*pi^(11/8);
    rcmax = num1 / (num2*num3*t^(3/4));
    rmax =  num1*t^(1/4) / (num2*num3);
end

%% Function to calculate effective capacitance of Coil
function Ceff = queryC(s,rc,r)                              % pitch, cross section, radius of coil
  global e0                                              
  sc = s/(2*rc);                                            % Conenience variable
  Ceff  = 2*(pi^2)*r*e0/log(sc + sqrt(sc^2-1));             % Self Capacitance of the coils [F] (3.21)
end

%% Solve for Optimal Capacitance + consequent coil spacing 
function [smax, Ct] = cap_spacing(L,r,rc,f)
  global e0
  Ct      = 1/(4*L*(pi^2)*(f^2));                           % Capacitance required to meet res freq (f=1/2*pi*sqrt(L*C)) (3.22)             
  smax    = (exp(4*pi^4*r^2*e0^2/Ct^2)+1)*rc;               % Maximum (optimal) spacing between coils
  smax    = smax / exp(2*pi^2*r*e0/Ct);                     % Formula continued [m] (3.23)
end

%% AWG to cross-sectional radius in meters
function rc = awg2m(n)
    dc = 0.127*92^((36-n)/39);
    rc = dc*1E-3/2;
end

%%Cross-sectional to AWG
function awg = m2awg(m)
    dn = m*2*1E3;
    awg = -39*log(dn/0.127)/log(92)+36;
end

function m = in2m(in)
 m = in*0.0254;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printResults(r,rc,pitch,N,L,excap,C,f0,Q,Ct,s,Qmax,Qm,Ql,fr,Gamma, Ro, Rr)
 global c 
 fprintf('\n************************************\n');
 fprintf('************************************\n');
 
 fprintf('\nCoil Geometry\n');
 fprintf('~~~~~~~~~~~~~~~~~~~~\n');
 fprintf('Cross-sectional radius = %3.5f mm (%i AWG)\n',rc*1E3,round(m2awg(rc)));
 fprintf('Loop radius            = %3.5f cm (%f in)\n', r*1E2, 39.3701*r);
 fprintf('Loop diameter          = %3.5f cm (%f in)\n', r*1E2*2, 39.3701*r*2);
 fprintf('Pitch                  = %3.5f cm (%f in)\n', pitch*1E2, 39.3701*pitch);
 fprintf('N                      = %2.2f turns\n', N);
 fprintf('Length of wire/tube    = %3.3f cm (%f ft)\n', 2*pi*r*N*1E2, 3.28084*2*pi*r*N);
 
 fprintf('\nCoil Geometry Predictions\n');
 fprintf('~~~~~~~~~~~~~~~~~~~~\n');
 fprintf('Estimated f0           = %f MHz\n', f0*1E-6);      % true resonant frequnecy given geometry
 fprintf('Estimated wavelength   = %f m\n', c/f0);           % corresponding wavelength of true resonant frequnecy'
 fprintf('Estimated L            = %f uH\n', L*1E6);         % true inductance given geometry
 fprintf('Estimated C            = %f pF\n', C*1E12);        % true capacitance given geometry
 if excap==0
   fprintf('External Capacitor     =  N/A\n');
 else
   fprintf('External capacitor   = %f pF\n', excap*1E12);    % External capacitor value
   fprintf('Estimated C total    = %f pF\n',(C+excap)*1E12); % Total parallel capacitance
 end
  fprintf('Estimated Q            = %f \n', Q);              % corresponding Q of f0 and geometry

  fprintf('~~~~~~~~~~~~~~~~~~~~\n');                         % Theoretical optimal, sketchy results
  fprintf('Optimal coil pitch     = %f cm\n', s*1E2);
  fprintf('Qglobal                = %f\n', Qmax);           
  fprintf('Q_from_plot            = %f\n', Qm);
  fprintf('Ql                     = %f\n', Ql);
  fprintf('fr                     = %f MHz\n', fr*1E-6);
  fprintf('Ct                     = %f pF\n', Ct*1E12); 
  fprintf('Gamma (Loss)           = %f\n', Gamma);
  fprintf('Radiation Resistance   = %f Ohms\n', Rr);
  fprintf('Ohmic Resistance       = %f Ohms\n', Ro);
end

