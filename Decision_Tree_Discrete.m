clear;
fid=fopen('Iris Dataset\iris.data');
C=textscan(fid, '%f%f%f%f%s','delimiter',',');
fclose(fid);%使用textscan函数读取文件，输出C细胞数组，每个数组中存放每列的数据
% [attrib1,attrib2,attrib3,attrib4,class]=textread('Iris Dataset\iris.data','%f%f%f%f%s','delimiter',',');%旧方法
attributesO=[C{1,1},C{1,2},C{1,3},C{1,4}];
ClassO=zeros(150,1);
ClassO(strcmp(C{1,5},'Iris-setosa')) = 1;
ClassO(strcmp(C{1,5},'Iris-versicolor')) = 2;
ClassO(strcmp(C{1,5},'Iris-virginica')) = 3;
%提取测试集和训练集
%R=ceil(100+50*rand());
% Ta1=attributesO(25,:);
% Ta2=attributesO(75,:);
%Ta3=attributesO(R,:);
% attributesO(25,:)=[];
% attributesO(75,:)=[];
%attributesO(R,:)=[];
% ClassO(25,:)=[];
% ClassO(75,:)=[];
% ClassO(R,:)=[];
%完成
[attributes{1,1},Class{1,1},height(1,1),Node{1,1}]=Brunch(attributesO,ClassO,[],[]);
for n=1:1000        
    k=1;
    for m=1:1000        
        [~,W]=size(height);
        if m>W||height(n,m)==0
            break;
        end
        for i=1:height(n,m)
            if Node{n,m}(i,5)==0
                attributes{n,m}{i}(:,Node{n,m}(i,3))=[];
                [attributes{n+1,k},Class{n+1,k},height(n+1,k),Node{n+1,k}]=Brunch(attributes{n,m}{i},Class{n,m}{i},Node{n,m}(i,4),m);
                k=k+1;
            end
        end
    end
    [H,~]=size(height);
    if n==H
        break;
    end
end
% Test=Ta3;
% LN=0;
% Arr=1;
% MaxM=sum(height~=0,2);
% for i=1:length(MaxM)
%     for j=1:MaxM(i)
%         if Node{i,j}(1,1)~=LN||(Node{i,j}(1,1)~=0&&Node{i,j}(1,2)~=Test(Arr))
%             continue;
%         end
%         if i~=1
%             Test(Arr)=[];
%         end
%         Arr=Node{i,j}(1,3);
%         for k=1:height(i,j)
%             if Test(Arr)==Node{i,j}(k,4)
%                 Output=Node{i,j}(k,5);
%                 LN=j;
%             end
%         end
%     if Output~=0
%         break;
%     end
%     end
%     if Output~=0
%         break;
%     end
% end

% for i=1:height(1,1)
%     if Node{1,1}(i,5)==0
%         attributes{1,1}{i}(:,Node{1,1}(i,3))=[];
%         [attributes{2,k},Class{2,k},height(2,k),Node{2,k}]=Brunch(attributes{1,1}{i},Class{1,1}{i},Node{1,1}(i,3:4));
%         k=k+1;
%     end
% end

% for i=1:height1
%     if Node1(i,5)==0
%         attributes1{i}(:,E1)=[];
%         eval(['[E2',num2str(k),',attributes2',num2str(k),',Class2',num2str(k),',height2',num2str(k),',Node2',num2str(k),']=Brunch(attributes1{i},Class1{i},Node1);'])
%         k=k+1;
%     end
% end

% EnC=Entropy_of_All(Class);
% [~,Na]=size(attributes);
% for i=1:Na
%     eval(['[En',num2str(i),',Ens',num2str(i),',s',num2str(i),']=Entropy_of_A(',num2str(i),',attributes,Class);']);
% end
% IG=zeros(Na,1);
% for i=1:Na
%     IG(i)=EnC-eval(['En',num2str(i)]);
% end

% [height,width]=size(Ia1);
% Ens=zeros(1,height);
% s=cell(1,height);
% for i=1:height
%     k=1;
% for j=1:150
%     if attributes(j,1)==Ia1(i,1)
%         T1C(k)=Class(j);
%         k=k+1;
%     end
% end
% s{i}=tabulate(T1C);
% [hs,ws]=size(s{i});
% for j=1:hs
%     if s{i}(j,3)~=0
%      Ens(1,i)=Ens(1,i)-0.01*s{i}(j,3)*log2(0.01*s{i}(j,3));
%     end
% end
% end
% En1=0;
% for i=1:height
%     En1=En1+0.01*Ia1(i,3)*Ens(1,i);
% end

% [NC,~]=histcounts(Class);
% LN=length(NC);
% EnAll=0;
% AN=sum(NC);
% p=zeros(1,LN);
% for i=1:LN
%     p(i)=NC++++(i)/AN;
% end
% for i=1:LN
%     EnAll=EnAll-p(i)*log2(p(i));
% end
% [~,NoA]=size(attributes);
% for i=1:NoA
%     [NA(i),~]=histcounts(attributes(:,i));
% end