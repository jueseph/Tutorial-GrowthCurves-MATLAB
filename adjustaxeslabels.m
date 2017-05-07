function adjustaxeslabels(dim,coords,flag)
% ADJUSTAXESLABELS(DIM, COORDS, FLAG) hides or shows axis and tick labels
% on the current axes so that labels don't appear on inside panels in a
% closely spaced grid of subplots. This assumes that the current axes
% handle corresponds to a subplot at position COORDS = [Ri, Ci] in a grid of plots
% of dimension DIM = [NROWS NCOLS]. When FLAG is set to true (default =
% false), labels will be omitted from all panels other than the bottom-left
% panel. This function is best used when looping through subplots generated
% by GRIDPLOT.
%
% See GRIDPLOTDEMO for an example of usage.
%
% 20130416
if length(coords)==1
    [c,r]=ind2sub(fliplr(dim),coords);
else
    r = coords(1);
    c = coords(2);
end

if ~exist('flag','var')
    flag=false;
end

if flag
    % labels only on bottom left plot
    if c==1 && r==dim(1)
        %         set(gca,'xticklabelmode','auto')
        %         set(gca,'yticklabelmode','auto')
    else
        xlabel([])
        ylabel([])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
    end
else
    % labels on all outside plots
    if c~=1
        set(gca,'yticklabel',[])
        ylabel([])
    end
    if r~=dim(1)
        set(gca,'xticklabel',[])
        xlabel([])
    end
end