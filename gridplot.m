function[ hf ha] = gridplot(varargin)
% GRIDPLOT creates a figure with a grid of NROWS x NCOLS plots, each of
% which is WIDTH pixels wide and HEIGHT pixels high. Margins and gaps are
% hard-coded for a typical screen setup to leave room for axes labels
% 
%   GRIDPLOT with no arguments creates a single 800x600px plot with white
%   background.
% 
%   [HF HA] = GRIDPLOT(NROWS, NCOLS, WIDTH, HEIGHT) creates a grid of NROWS
%   x NCOLS plots that are each WIDTH x HEIGHT pixels in dimension. The
%   axes handle of the plot in position (Ri,Ci) is given by
%   HA(sub2ind([NCOLS, NROWS],Ci,Ri)). Note the inversion of row and column
%   indices to deal with MATLAB's inconsistent dimension order on subplots
%   and matrices.
% 
%   GRIDPLOT(NROWS, NCOLS, WIDTH, HEIGHT, 'gapvert', 2, 'margtop', 50)
%   functions as above, except the vertical space between plots is 2
%   pixels, and the space above the grid of plots is 50 pixels. Other
%   options are 'gaphorz', 'margleft', 'margright', and 'margbot'.
%   
%   Use in conjunction with ADJUSTAXESLABELS to grids of many plots with
%   shared axes and tick labels.
%   
% Created 20131101 JW
% Updated 20141103 JW
p = inputParser;
addOptional(p,'nrows',1,@isnumeric);
addOptional(p,'ncols',1,@isnumeric);
addOptional(p,'width',600,@isnumeric);
addOptional(p,'height',500,@isnumeric);
addParamValue(p,'margleft',80,@isnumeric);
addParamValue(p,'margright',25,@isnumeric);
addParamValue(p,'margbot',50,@isnumeric);
addParamValue(p,'margtop',25,@isnumeric);
addParamValue(p,'gapvert',50,@isnumeric);
addParamValue(p,'gaphorz',50,@isnumeric);
addParamValue(p,'gap',[],@isnumeric);

parse(p, varargin{:});
nrows = p.Results.nrows;
ncols = p.Results.ncols;
width = p.Results.width;
height = p.Results.height;
margbot = p.Results.margbot;
margtop= p.Results.margtop;
margleft = p.Results.margleft;
margright = p.Results.margright;
gapvert = p.Results.gapvert;
gaphorz= p.Results.gaphorz;
gap = p.Results.gap;

if ~isempty(gap)
    gaphorz = gap;
    gapvert = gap;
end

figwidth = margleft + margright + ncols*width + (ncols-1)*gaphorz;
figheight = margbot + margtop + nrows*height + (nrows-1)*gapvert;

% centered on screen
screen = get(0,'screensize');
bottompx = max((screen(4) - figheight)./2, 10);
leftpx = max((screen(3) - figwidth)./2, 10);

hf = figure('position',[leftpx bottompx figwidth figheight]);

%     h = tight_subplot(3,3,[.05 .05],[.07 .03],[.02 .01]);
ha = tight_subplot(nrows,ncols,[gapvert gaphorz],[margbot margtop],[margleft margright],'pixels');
set(hf,'color','w')
set(0,'defaulttextinterpreter','none')

function ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w, units)

% tight_subplot creates "subplot" axes with adjustable gaps and margins
%
% ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w)
%
%   in:  Nh      number of axes in hight (vertical direction)
%        Nw      number of axes in width (horizontaldirection)
%        gap     gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%        marg_h  margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%        marg_w  margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 
%
%  out:  ha     array of handles of the axes objects
%                   starting from upper left corner, going row-wise as in
%                   going row-wise as in
%
%  Example: ha = tight_subplot(3,2,[.01 .03],[.1 .01],[.01 .01])
%           for ii = 1:6; axes(ha(ii)); plot(randn(10,ii)); end
%           set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','')

% Pekka Kumpulainen 20.6.2010   @tut.fi
% Tampere University of Technology / Automation Science and Engineering

% Modified 20120821 JW: can optionally use non-normalized units

if exist('units')~=1
    units = 'normalized';
end

if nargin<3; gap = .02; end
if nargin<4 || isempty(marg_h); marg_h = .05; end
if nargin<5; marg_w = .05; end

if numel(gap)==1; 
    gap = [gap gap];
end
if numel(marg_w)==1; 
    marg_w = [marg_w marg_w];
end
if numel(marg_h)==1; 
    marg_h = [marg_h marg_h];
end

fheight = 1;
fwidth = 1;

if strcmpi(units,'pixels')
%     set(gcf,'units','pixels');
    pos = get(gcf,'position');
    fwidth= pos(3);
    fheight = pos(4);
end

axh = (fheight-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (fwidth-sum(marg_w)-(Nw-1)*gap(2))/Nw;

py = fheight-marg_h(2)-axh; 

ha = zeros(Nh*Nw,1);
ii = 0;
for ih = 1:Nh
    px = marg_w(1);
    
    for ix = 1:Nw
        ii = ii+1;
        ha(ii) = axes('Units',units, ...
            'Position',[px py axw axh], ...
            'XTickLabel','', ...
            'YTickLabel','');
        px = px+axw+gap(2);
    end
    py = py-axh-gap(1);
end

