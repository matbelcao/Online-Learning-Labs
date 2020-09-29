function plotCheckerBoardDataSet(DataSet , Labels , label1 , label2 ,figureNumber)

figure(figureNumber),
index1 = find(Labels == label1)';
index2 = find(Labels == label2)';
plot(DataSet(1 , index1) , DataSet(2 , index1) , 'bo');
hold on,
plot(DataSet(1 , index2) , DataSet(2 , index2) , 'rx');
hold off,
axis equal
axis tight