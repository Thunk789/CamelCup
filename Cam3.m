clear all
close all
clc
%% Version notes:
% Cam: Performs individual dice rolls and new positions for all cams
% Cam1:Brute force probability calculator
% Cam2:inputs for dice rolls yet to happen
% Cam3:Add Value calcs for betting cards, Add Desert+Oasis


%%%SET UP%%%
%positions
%Green
g=3.6;
%Orange
o=3;
%Blue
b=4;
%White
w=3.8;
%Yellow
y=6;

%Desert/Oasis layout
Desert=[];
Oasis=[5];

%Dice status
%   G O B W Y   1=yet to be rolled
DS=[1,0,0,1,1];

%Betting Cards Status
%   G O B W Y   #=number of cards left (3= 5 coin on top, 2= 3 coin on top, etc.)
CS=[3,3,1,3,3];
CSV=floor((CS.*1.9)+.1);



%%%PROGRAM%%%
P=perms(nonzeros([1,2,3,4,5].*DS)); %all possible roll orders
D=dec2base([0:(3^sum(DS)-1)]',3); %all possible dice combos
Pos=[g,o,b,w,y;0,0,0,0,0];
Win=[0,0,0,0,0];

for p=1:length(P) %for each roll order
  for d=1:length(D) %for each roll combo
    r=1; %cycle counter (r=2 is the second position, after roll 1)
    
    for j=1:length(P(1,:)) %for each die to roll
      r=r+1;
      %after roll positions
      Pos(r,P(p,j))=Pos(r-1,P(p,j))+str2num(D(d,j))+1; %move the one that rolled first 
      n1=ceil(Pos(r-1,:))==ceil(Pos(r-1,P(p,j)));
      n2=Pos(r-1,:)>=Pos(r-1,P(p,j));
      n=sum(n1.*n2);  %number of cams moving
      
      for i=1:5 %treat each cam
        if ceil(Pos(r-1,i))==ceil(Pos(r-1,P(p,j)))&&Pos(r-1,i)>=Pos(r-1,P(p,j))  %for cams that move forward
          Pos(r,i)=Pos(r-1,i)+str2num(D(d,j))+1;
        elseif ceil(Pos(r-1,i))==ceil(Pos(r-1,P(p,j))+str2num(D(d,j))+1)  %for cams that get jumped on
          Pos(r,i)=Pos(r-1,i)-(.2*n);
        elseif ceil(Pos(r-1,i))==ceil(Pos(r-1,P(p,j)))  %for cams that get left behind
          Pos(r,i)=Pos(r-1,i)+(.2*n);
        else  %for cams that dont move
          Pos(r,i)=Pos(r-1,i);
        endif
      endfor
      if sum(ceil(Pos(r,P(p,j)))==Oasis)>0 %if the rolled camel is on an Oasis
        Pos(r,:)=Pos(r,:)-((ceil(Pos(r,:))==ceil(Pos(r,P(p,j))+1)).*(.2*n));  %lower cams on the next space
        Pos(r,:)=Pos(r,:)+(ceil(Pos(r,:))==ceil(Pos(r,P(p,j))));  %move stack of Oasis cams
      elseif sum(ceil(Pos(r,P(p,j)))==Desert)>0 %if the rolled camel is on a Desert
        Pos(r,:)=Pos(r,:)-((ceil(Pos(r,:))==ceil(Pos(r,P(p,j)))).*(1+(.2*sum(ceil(Pos(r,:))==ceil(Pos(r,P(p,j))-1)))));
      endif
    endfor
    Win(find(max(Pos(end,:))==Pos(end,:)))=Win(find(max(Pos(end,:))==Pos(end,:)))+1;  %count winners
  endfor
endfor

%Simulation results
Green=Win(1)/sum(Win)
GreenV=Green*CSV(1);
Orange=Win(2)/sum(Win)
OrangeV=Orange*CSV(2);
Blue=Win(3)/sum(Win)
BlueV=Blue*CSV(3);
White=Win(4)/sum(Win)
WhiteV=White*CSV(4);
Yellow=Win(5)/sum(Win)
YellowV=Yellow*CSV(5);

