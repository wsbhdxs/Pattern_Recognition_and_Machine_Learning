function DT_Plot(MaxM,Node,D)
figure;
h=1/(length(MaxM)+1);
w=zeros(1,length(MaxM)+1);
py=zeros(length(MaxM),max(MaxM));
drx=zeros(length(MaxM),max(MaxM));
dlx=zeros(length(MaxM),max(MaxM));
w(1)=0.25;
for i=1:(length(MaxM)+1)
    if i~=1
        w(i)=0.6*w(i-1);
    end
    py(i,:)=h*(length(MaxM)+2-i)*ones(1,max(MaxM));
end
px=zeros(length(MaxM),max(MaxM));
for i=1:length(MaxM)
    for j=1:MaxM(i)
        if i==1&&j==1
            px(i,j)=0.5;
            continue;
        end
        if Node{i,j}(1,2)==1;
            px(i,j)=px(i-1,Node{i,j}(1,1))+w(i);
        else
            px(i,j)=px(i-1,Node{i,j}(1,1))-w(i);
        end
    end
end
for i=1:length(MaxM)
    for j=1:MaxM(i)
        for k=1:2
            if Node{i,j}(k,5)~=0;
                if Node{i,j}(k,4)==1;
                    drx(i,j)=px(i,j)+w(i+1);
                else
                    dlx(i,j)=px(i,j)-w(i+1);
                end
            end
        end
    end
end
xmax=max([max(max(px)) max(max(drx)) max(max(dlx))]);
xmin=min([min(min(px(px~=0))) min(min(drx(drx~=0))) min(min(dlx(dlx~=0)))]);
LO=xmax-xmin;
px=(px-xmin+0.05)/LO*0.8;
drx=(drx-xmin+0.05)/LO*0.8;
dlx=(dlx-xmin+0.05)/LO*0.8;
for i=1:length(MaxM)
    for j=1:MaxM(i)
        if i~=1
        annotation('textarrow',[px(i-1,Node{i,j}(1,1)) px(i,j)],[py(i-1,j) py(i,j)]);
        end
        for k=1:2
            if Node{i,j}(k,5)~=0;
                if Node{i,j}(k,4)==1;
                    annotation('textarrow',[px(i,j) drx(i,j)],[py(i,j) py(i+1,j)]);
                    annotation('textbox',[drx(i,j) py(i+1,j) 0 0],'String',num2str(Node{i,j}(k,5)),'FitBoxToText','on','HorizontalAlignment','center','LineStyle','none');
                else
                    annotation('textarrow',[px(i,j) dlx(i,j)],[py(i,j) py(i+1,j)]);
                    annotation('textbox',[dlx(i,j) py(i+1,j) 0 0],'String',num2str(Node{i,j}(k,5)),'FitBoxToText','on','HorizontalAlignment','center','LineStyle','none');
                end
            end
        end
    end
end
for i=1:length(MaxM)
    for j=1:MaxM(i)
        annotation('textbox',[px(i,j) py(i,j) 0 0],'String',['x',num2str(Node{i,j}(1,3)),'<',num2str(D(i,j)),'~','x',num2str(Node{i,j}(1,3)),'>',num2str(D(i,j))],'FitBoxToText','on','HorizontalAlignment','center','BackgroundColor','w','Margin',2);
    end
end
ax = gca;
ax.Color = 'none';
ax.XAxis.Color = 'none';
ax.YAxis.Color = 'none';