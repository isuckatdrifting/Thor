clc
clear all
close all
s=serial('com4');
set(s,'BaudRate', 115200,'DataBits',8,'StopBits',1,'Parity','Even','FlowControl','none'); 
s.BytesAvailableFcnMode='byte';  % ????
s.InputBufferSize=102400;
s.OutputBufferSize=1024;
s.BytesAvailableFcnCount=100;
s.ReadAsyncMode='continuous';
s.Terminator='CR';
buff = 102400;
fopen(s);                  %????
out=fread(s,buff);   %????10???  
fprintf('%d ',out);        %?????????,%c???%d??
k = 1;
temp = zeros(1000,3);

for i=1:buff-3
    if out(i,1)==85
        temp(k,1) = out(i+1,1);
        temp(k,2) = out(i+2,1);
        temp(k,3) = out(i+3,1);
        k = k+1;
    end
end
temp2(:,1) = temp(:,1);
char = dec2bin(temp(:,2));
temp2(:,2) = bin2dec(char(:,1:4));
temp2(:,3) = bin2dec(char(:,5:8));
temp2(:,4) = temp(:,3);
temp3(:,1) = (temp2(:,1)*16+temp2(:,2));
temp3(:,2) = (temp2(:,3)*256+temp2(:,4));

leng = size(temp3,1);
temp4 = zeros(leng,2);
for j=1:leng
    if temp3(j,1)>2000
        temp4(j,1) = temp3(j,1)-2048;
    else
        temp4(j,1) = temp3(j,1);
    end
    if temp3(j,2)>2000
    temp4(j,2) = temp3(j,2)-2048;
    else
    temp4(j,2) = temp3(j,2);
    end
end

%scatter(temp4(:,1)*2,temp4(:,2)*2);

leng = size(temp4,1);
k = 1;
for j = 1:leng
    if temp4(j,1)> 250 && temp4(j,1)<750 && temp4(j,2)>500 && temp4(j,2)<1250
        temp5(k,1) = temp4(j,1)*2;
        temp5(k,2) = temp4(j,2)*2;
        k = k +1;
    end
end
temp6 = sortrows(temp5,2);

leng5 = size(temp5,1);
n = 1;p = 1;
for m = 1:leng5
    if temp6(m,2) < 2000
        temp7(n,1) = temp6(m,1);
        temp7(n,2) = temp6(m,2);
        n = n + 1;
    else 
        temp8(p,1) = temp6(m,1);
        temp8(p,2) = temp6(m,2);
        p = p + 1;
    end
end

figure
subplot(1,2,2);
scatter(temp6(:,1),temp6(:,2));
hold on
y1 = polyfit(temp7(:,1),temp7(:,2),1);
y2 = polyfit(temp8(:,1),temp8(:,2),1);

v = 500:0.0001:1500;
ans1 = y1(1,1).*v+y1(1,2);
ans2 = y2(1,1).*v+y2(1,2);
plot(v,ans1,'Linewidth',3);
hold on
plot(v,ans2,'Linewidth',3);

deltavc = y2(1,2)-y1(1,2); %unit:mv
A1 = 2;
A2 = 0.815;
Vpp = 2.60;
step = 7;
Rb = 100;
Rc = 1;
deltaic = deltavc/1000/A2/Rc ;
deltaib = Vpp/step/Rb;
beta = deltaic / deltaib;

subplot(1,2,1);
scatter(temp4(:,1)*2,temp4(:,2)*2);
hold on
plot([500,1500],[1000,1000],'r');
hold on 
plot([500,1500],[2500,2500],'r');
hold on
plot([500,500],[1000,2500],'r');
hold on
plot([1500,1500],[1000,2500],'r');
ylabel('Ic');
xlabel('Vce');
title(['\beta = ' num2str(beta)],'fontsize',12);
fclose(s);