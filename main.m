clear;
clc;
addpath ('D:/machinelearning/CMPS-4720-6720/final program/final');

% get the whole data after first process 
load('HousingPrice.mat');

% transform the data matrix
data = price';

% sample number = 1460;
A = rand(1,1460);
[m,n]=sort(A);

Features0 = data(2:21,:);
Features = [Features0;ones(1,1460)];
Prices = data(22,:);

% randomly divide them into two groups test&training
% training group 1360
% test group 100
train_F = Features(:,n(1:1360));
train_P = Prices(:,n(1:1360));
test_F = Features(:,n(1361:1460));
test_P = Prices(:,n(1361:1460));

%input normalizing
[trainf,fs]=mapminmax(train_F);
[trainp,ps]=mapminmax(train_P);

%mapminmax('reverse',,fs)

%�����������Ԫ������Χ�� Hornik ����Ĺ�ʽ��
%N=[(2n + m)^(1/2) ,2n+m]ȷ�������� N Ϊ��������������Ԫ������n Ϊ��������Ԫ����m Ϊ�����ڵ������
%�й��о�֤��������ѵ�����ȵ���ߣ����Բ���һ�����㣬����������Ԫ�����ķ�����ʵ�֣���������������������ķ����򵥵Ķ�
%1�����������ȷ��
%������֤��:����ƫ�������һ��S ���������һ�����������������磬�ܹ��ƽ�
%�κ�������������Ԥ��ģ�Ͳ������������磬������㡪���㡪�����ṹ[6]��
%2�����㵥Ԫ����ȷ��
%�й��о�֤��������ѵ�����ȵ���ߣ����Բ���һ�����㣬����������Ԫ�����ķ���
%��ʵ�֣���������������������ķ����򵥵Ķ�[7]��
%3����ʼȨֵ��ѡȡ
%������ڵ�ĳ�ʼֵΪ��Ϊ�ֲ����㸽���ĺ�С�����ֵ���������ڵ�������Ȩֵ��
%��һ��Ϊ+1����һ��Ϊ-1������ڵ��ƫ�ã��ȣ�ͳһ����Ϊ�㡣
%4����Ӧ������ѡȡ
%����Sigmoid �����Ŀ�΢�ԣ���΢��ʽ�򵥣����ڱ�ʾ��ͬʱ�����кܺõķ�����ӳ��
%���������Զ���Ϊӳ�亯�������о�������Sigmoid �������
%1��ѵ���㷨��ѡ��
%LM �㷨�����ڽ�����й�ģ���⣬�����ڽ�����ģ����ʱ��LM �㷨����ͻ����
%�ŵ㣺һ�ε�����ʹ��������½������о�������LM �㷨��
%create BP neural network using LM
BPnet = newff(trainf,trainp,[40],{},'traingdx');

BPnet.trainParam.max_fail=15;
BPnet.trainParam.epochs=100000;
BPnet.trainParam.goal = 1e-8;
%BPnet.trainParam.

BPnet=train(BPnet,trainf,trainp);

%  �� BP ������з���

%  ���������� 
E = trainp - BPnet(trainf);
MSE=mse(E)
% predict BP
[testf,tfs]=mapminmax(test_F);
[testp,tps]=mapminmax(test_P);
outputs=BPnet(testf);
predictP = mapminmax('reverse',outputs,tps);

error=test_P-predictP;
error=mse(error);
error = error^(1/2);



%use gradient descent 
BPnet_GD = newff(trainf,trainp,[30],{},'traingd');

BPnet_GD.trainParam.max_fail=200;
BPnet_GD.trainParam.epochs=50000;
BPnet_GD.trainParam.goal = 1e-5;

BPnet_GD=train(BPnet_GD,trainf,trainp);

E = trainp - BPnet_GD(trainf);
MSE=mse(E)

outputs=BPnet_GD(testf);
predictP = mapminmax('reverse',outputs,tps);


error=test_P-predictP;
error=mse(error);
error = error^(1/2);

%simple linear regression
linP = Prices';
linX = [Features0',ones(1460,1)];
[b,bint,r,rint,stats]= regress(linP,linX);


%compare neural network and linear regression



