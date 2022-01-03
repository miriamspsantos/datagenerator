function plotDataTypes(filename_arff,savePlot)
% plotDataTypes shows and saves the figures regarding certain configuration
% files (in .arff format).
%
%   INPUT:
%   'filename' is a string with the name or filepath (.arff file)
%   'savePlot' is a flag to indicate whether the plot shoud be saved
%
%   OUTPUT:
%       This function simply presents the figure regarding the file
%       and may also save it if varargin is defined.
%
%
%   EXAMPLE:
%       plotDataTypes('paw3-2d.arff',0);
%       plotDataTypes('paw3-2d.arff',1);
%
%
%   NOTES:  
%   At this point, the specification is the following:
% 
%   (1) "1" is assumed the "minority" class
% 
%   (2) .arff files created by the data generator either contain:
%       @attribute CLASS {MIN,MAJ}
%       or
%       @attribute D {1,2}
%       or
%       @attribute LABEL {1-SAFE,1-BORDER,1-RARE,1-OUTLIER,1-DEFAULT,2
%       or
%       @attribute LABEL {MIN-SAFE,MIN-BORDER,MIN-RARE,MIN-OUTLIER,MIN-DEFAULT,MAJ}
% 
%   (3) If the dataset is 2 or 3D, the data is plotted with the respective
%       dimensionality. Otherwise (i.e., dim > 3), PCA is performed and
%       data is plotted in 2D (first 2 principal components).
%
% 
% Copyright: Miriam Santos, 2021

close all;
dataOut = arff2double(filename_arff);
X = dataOut.X;
Y = dataOut.Y;

classes = unique(Y);
Legends = {};

for i = 1:numel(classes)
    j = classes(i);
    Xj = X(Y == j, :);
    Color = [0 0 0];
    if j == 1 % Minority Class (or Safe)
        if max(classes) == 2
            Legends{end+1} = 'MIN';
        else
            Legends{end+1} = 'SAFE';
        end
        Style = 'o';
        MarkerSize = 8;
        MarkerFaceColor = [0.35 0.35 0.35];
    elseif max(classes) == 2
        Legends{end+1} = 'MAJ';
        Style = 'o';
        MarkerSize = 8;
        MarkerFaceColor = [0.9 0.9 0.9];
    else
        if j == 6 % Majority Class
            Style = 'o';
            MarkerSize = 8;
            MarkerFaceColor = [0.9 0.9 0.9];
            Legends{end+1} = 'MAJ';
        elseif j == 2 % Borderline
            Style = 'o';
            MarkerSize = 8;
            MarkerFaceColor = [1 0 0];
            Legends{end+1} = 'BORDER';
        elseif j == 3 % Rare
            Style = 'o';
            MarkerSize = 8;
            MarkerFaceColor = [0 1 1];
            Legends{end+1} = 'RARE';
        elseif j == 4 % Outlier
            Style = 'p';
            MarkerSize = 13;
            MarkerFaceColor = [0 0 0];
            Legends{end+1} = 'OUTLIER';
        else
            continue;
        end
    end
    
    dim = size(X,2);
    if dim == 2
        plot(Xj(:,1),Xj(:,2),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',MarkerFaceColor);
    elseif dim == 3
        plot3(Xj(:,1),Xj(:,2), Xj(:,3),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',MarkerFaceColor);
    else
        [~,score] = pca(X);
        score_j = score(Y == j,1:2);
        plot(score_j(:,1),score_j(:,2),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',MarkerFaceColor);
    end
    hold on;
end

ax = gca;
ax.Visible = 'off';
legend(Legends, 'FontSize', 14);
legend('Location', 'NorthEastOutside');
axis_ch = [ax.Children(2:end); ax.Children(1)];
set(ax,'Children',axis_ch)
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

if savePlot    
    filename = erase(filename_arff,'.arff');
    saveas(gcf, filename, 'png');
end



end



