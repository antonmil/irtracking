clear;
clear all;
clear;

%data=load('C:\matlab³ÌÐò\fall detection2/continuous_monitor-sasaki.txt');
%data=load('C:\matlab³ÌÐò\fall detection2\4.txt');
data=load('data\foward_fall2.txt');
H=20;
%%% X and Y are the coordiates of 20 sensors
X=[37.5 112.5 187.5 262.5 337.5 37.5 112.5 187.5 262.5 337.5 37.5 112.5 187.5 262.5 337.5 37.5 112.5 187.5 262.5 337.5];
Y=[37.5 37.5 37.5 37.5 37.5 112.5 112.5 112.5 112.5 112.5 187.5 187.5 187.5 187.5 187.5 262.5 262.5 262.5 262.5 262.5];

[M,N]=size(data);

%%% x and y are the estimated location at all the frames
x=zeros(1,M-H);
y=zeros(1,M-H);

%%%%%%%%%%calculated "pixel values"
Pix=zeros(M-H,20);

v=zeros(1,M-H-1);

for i=11:(M-H/2)
    Pix(i-10,:)=sum(data((i-10):(i+10),:))/(H+1);
    if sum(Pix(i-10,:))==0
        Pix(i-10,:)=Pix(i-11,:);
    end
end


for i=1:(M-H)
    sum_of_Pix=0;
    x(1,i)=0;
    for j=1:20
        x(1,i)=x(1,i)+Pix(i,j)*X(1,j);
        sum_of_Pix=sum_of_Pix+Pix(i,j);
    end
    x(1,i)=x(1,i)/sum_of_Pix;
end
for i=1:(M-H)
    sum_of_Pix=0;
    y(1,i)=0;
    for j=1:20
        y(1,i)=y(1,i)+Pix(i,j)*Y(1,j);
        sum_of_Pix=sum_of_Pix+Pix(i,j);
    end
    y(1,i)=y(1,i)/sum_of_Pix;
end
for i=2:(M-H) %%% calculate the speed
    v(1,i-1)=sqrt((x(1,i)-x(1,i-1))^2+(y(1,i)-y(1,i-1))^2);
    if v(1,i-1)>30 
        v(1,i-1)=0;
    end
    if i>2 & v(1,i-2)<2 & v(1,i-1)>10
        v(1,i-1)=0;
    end
end
save updown2.txt Pix -ascii;
save v.txt v -ascii;
%[M_value,p_value,s_value,points]=change_detect(v(1:50));
     
plot(v);
axis([0 M-H 0 30]);    %M-H

%[m,n]=size(v);
%for i=1:(n-1)
%    v(i)=v(i+1)-v(i);
%end
%v=v(1:4000);

%MM=fix(M/16);
%for i=1:(MM-1)
%    v(i)=sum(v((1+16*(i-1)):(16+16*(i-1))));
%end

%plot(v(1:(MM-1)));
%AXIS([0 MM-1 0 100]);


%%{


%%%%%%%%%%%%%%%%%%%%%%%initialize
change=[];
Lambda=2;
Epsilon=0.92;

%%%%%changesita for loop=1:80
for loop=7:10
%     loop
%     Lambda

change_points=[];
[m,n]=size(v);

%n=MM-1;
%mmmmm=mean(v);
%Lambda=2.5;
M0=1;
T=[];%% each of the data stream
s=zeros(1,n);%% strangeness
p=zeros(1,n);%% p-value
M=zeros(1,n);%% Martingale value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    [m1,n1]=size(T);
    %mmm=mean(v((i-n1):i));
    mmm=mean(v);
    if n1==0
        s(i)=0;
    else
        %if v(i)==0
        %    v(i)=mean(T)*0.95;
        %end
        
        for j=(i-n1):i
            s(j)=abs(v(j)-mmm);
        end
    end
    
    %s(i)=v(i);
    
    j1=0; 
    j2=0;
    for j=(i-n1):i
        if s(j)>s(i)
            j1=j1+1;
        end
        if s(j)==s(i)
            j2=j2+1;
        end
    end
    
    p(i)=(j1+unifrnd(0,1)*j2)/(n1+1);
    
    if i>1
        M(i)=M(i-1)*Epsilon*(p(i)^(Epsilon-1));
    end
    if i==1
        M(i)=M0*Epsilon*(p(i)^(Epsilon-1));
    end
    
    if M(i)>Lambda & v(i)>mmm
        change_points=[change_points,i];
        M(i)=1;
        T=[];
    else
        T=[T,v(i)];%%%%%%%
    end
    
end    

change=[change,change_points,0,Lambda]
Lambda=Lambda+1;

end



%}


