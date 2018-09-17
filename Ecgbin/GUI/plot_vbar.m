%x(:,1) pos
%x(:,2) duration

function plot_vbar(x ,fs ,  h , maxt , cr)

if nargin < 5
    cr = 'b';
end;
hold on;
for ii = 1: size(x,1)
    if x(ii,2) == -1
         plot([x(ii,1)/fs  maxt],[h h ] ,'b', 'LineWidth',5);
    else  
        plot([x(ii,1)/fs ( x(ii,1)+x(ii,2))/fs],[h h ] ,cr, 'LineWidth',5);
    end
end;
hold off;
