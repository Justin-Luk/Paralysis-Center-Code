tmp = readtable('MotorControlData.csv');
y_line_1= table2array(tmp(:,2));
x_line_1= table2array(tmp(:,1));
y_line_2= table2array(tmp(:,3));
y_line_3= table2array(tmp(:,4));
y_line_4= table2array(tmp(:,5));
y_line_5= table2array(tmp(:,6));
y_line_6= table2array(tmp(:,7));

index_closed_x = table2array(tmp(:,18));
index_closed_y = table2array(tmp(:,19));
index_closed_z = table2array(tmp(:,20));
index_neutral_x = table2array(tmp(:,21));
index_neutral_y = table2array(tmp(:,22));
index_neutral_z = table2array(tmp(:,23));
index_open_x = table2array(tmp(:,24));
index_open_y = table2array(tmp(:,25));
index_open_z = table2array(tmp(:,26));

distance_index = table2array(tmp(:,29))
distance_thumb = table2array(tmp(:,30))

thumb_closed_x = table2array(tmp(:,9));
thumb_closed_y = table2array(tmp(:,10));
thumb_closed_z = table2array(tmp(:,11));
thumb_neutral_x = table2array(tmp(:,12));
thumb_neutral_y = table2array(tmp(:,13));
thumb_neutral_z = table2array(tmp(:,14));
thumb_open_x = table2array(tmp(:,15));
thumb_open_y = table2array(tmp(:,16));
thumb_open_z = table2array(tmp(:,17));

figure('Name','Index Finger X','NumberTitle','off') 
plot(x_line_1,y_line_1,x_line_1,index_closed_x, x_line_1,index_neutral_x, x_line_1,index_open_x,'b-') 
figure('Name','Index Finger Y','NumberTitle','off') 
plot(x_line_1,y_line_2,x_line_1,index_closed_y, x_line_1,index_neutral_y, x_line_1,index_open_y,'b-') 
figure('Name','Index Finger Z','NumberTitle','off') 
plot(x_line_1,y_line_3,x_line_1,index_closed_z, x_line_1,index_neutral_z, x_line_1,index_open_z, 'b-')

figure('Name','Thumb Finger X','NumberTitle','off') 
plot(x_line_1,y_line_4,x_line_1,thumb_closed_x, x_line_1,thumb_neutral_x, x_line_1,thumb_open_x,'b-') 
figure('Name','Thumb Finger Y','NumberTitle','off') 
plot(x_line_1,y_line_5,x_line_1,thumb_closed_y, x_line_1,thumb_neutral_y, x_line_1,thumb_open_y,'b-') 
figure('Name','Thumb Finger Z','NumberTitle','off')
plot(x_line_1,y_line_6,x_line_1,index_closed_z, x_line_1,index_neutral_z, x_line_1,index_open_z, 'b-')

figure('Name','Distance Index','NumberTitle','off') 
plot(x_line_1,distance_index,'b-') 
figure('Name','Distance Thumb','NumberTitle','off') 
plot(x_line_1,distance_thumb,'b-') 