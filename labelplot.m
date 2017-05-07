function out = labelplot(plotlabel,varargin)
%LABELPLOT labels a plot.
% 20120803
% 20130103 changed 'EMPTY' condition JW
% 20130309 added location option.
parser = inputParser;
addParamValue(parser,'textoptions',{},@iscell);
addParamValue(parser,'fontsize',[],@isnumeric);
addParamValue(parser,'interpreter','tex',@ischar);
addParamValue(parser,'location','northwest',@ischar);
addParamValue(parser,'grayout',true,@islogical);

parse(parser,varargin{:});
textoptions = parser.Results.textoptions;
fontsize = parser.Results.fontsize;
location = parser.Results.location;
grayout = parser.Results.grayout;
interpreter = parser.Results.interpreter;

set(gca,'units','pixels');
dim = get(gca,'position');
wd = dim(3);
ht = dim(4);

hspace = min(max(wd./20, 10),5);
vspace = min(max(ht./10, 10),1);

% set text properties and defaults
if ispc, basefontsize = 12;
else basefontsize = 14; end
if isempty(fontsize)
    fontsize = min(basefontsize,calculate_fontsize(gca,8));
end
textoptions = [textoptions {'fontsize',fontsize,'interpreter',interpreter}];

if ~isempty(plotlabel)
    if ~isempty(strtrim( strrep(plotlabel,'EMPTY','')))
        % label plot
        if strcmpi(location,'northwest')
            text(hspace,ht-vspace,plotlabel,'units','pixels',...
                'verticalalignment','top',textoptions{:});
        elseif strcmpi(location,'southwest')
            text(hspace,vspace,plotlabel,'units','pixels',...
                'verticalalignment','bottom',textoptions{:});
        elseif strcmpi(location,'northeast')
            text(wd-hspace,ht-vspace,plotlabel,'units','pixels',...
                'verticalalignment','top','horizontalalignment','right',...
                textoptions{:});
        elseif strcmpi(location,'southeast')
            text(wd-hspace,vspace,plotlabel,'units','pixels',...
                'verticalalignment','bottom','horizontalalignment','right',...
                textoptions{:});
        end
    elseif grayout
        % gray out empty wells
        set(gca,'color',[.8 .8 .8]);
    end
end

set(gca,'units','normalized');

function marker_size = calculate_fontsize(fig_handle, ratio)

% define as the min of width and heigth of fig_handle, in unit of pixel
% by default, ratio is 20, fig_handle is gca
% try Fontsize_cal(gca, 20)
%
% written by Bo Hua

if nargin < 2
    ratio = 20;
end

if nargin <1
    fig_handle = gca;
end

backup = get(fig_handle, 'units');
set(fig_handle, 'units', 'pixels');
fig_dimensions = get(fig_handle, 'position');
marker_size = ceil(min(fig_dimensions(3), fig_dimensions(4))/ratio);
set(fig_handle, 'units', backup);