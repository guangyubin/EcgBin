function label = annmap(ann)

label = zeros(1,length(ann));
label(ann=='N' | ann=='R' | ann == 'L'| ann == 'e'| ann == 'j'|ann=='.'...
    |ann=='Q' | ann=='f' | ann == '/' |...
    ann=='F') = 1;
label(ann=='a' | ann=='J' | ann == 'S'|ann=='A' ) = 2;
label(ann=='V' | ann=='E' ) = 3;
% label(ann=='F' ) = 4;

% label = zeros(1,length(ann));
% label(ann=='N' | ann=='R' | ann == 'L'| ann == 'e'| ann == 'j'|ann=='.') = 1;
% label(ann=='a' | ann=='J' | ann == 'S'|ann=='A' ) = 2;
% label(ann=='V' | ann=='E' ) = 3;
% label(ann=='F' ) = 4;
% label(ann=='Q' | ann=='f' | ann == '/' ) = 5;

             
        
        