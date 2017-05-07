function metaarray = load96wmeta(filename)
%LOAD96WMETA
%
%   20120801
%   20120803 updated to change blank wells to 'EMPTY'
%   20120821 can now load a sequence of files
%   20120920 renamed loadstrainnames->load96wmeta

metaarray = {};

meta=csv2cell(filename);
nrows = size(meta,1);
nplates = idivide(int32(nrows),9)+1;

if mod(nrows,9)<8 || size(meta,2)<12
    meta{nplates.*9-1,12}='';
end

for iplate = 1:nplates
    metaarray(:,:,iplate)=meta((iplate*9-8):(iplate*9-1),1:12);
end

for c=1:numel(metaarray)
    if isempty(metaarray{c})
        metaarray{c} = 'EMPTY';
    end
end