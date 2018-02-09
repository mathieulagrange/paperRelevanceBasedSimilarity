fid = fopen('/data/databases/environment/dcaseScene/TUT-acoustic-scenes-2016-evaluation/evaluation_setup/evaluate.txt');
C = textscan(fid, '%s\t%s\t%s')
fclose(fid);

ori = C{1};
dest = C{3};
typo = C{2};

fid = fopen('/data/databases/environment/dcaseScene/TUT-acoustic-scenes-2016-evaluation/meta2.txt', 'w');

for k=1:length(ori)
    fprintf(fid, '%s\t%s\n', dest{k}, typo{k});
    copyfile(['/data/databases/environment/dcaseScene/TUT-acoustic-scenes-2016-evaluation/' ori{k}], ...
        ['/data/databases/environment/dcaseScene/dcase2016/' dest{k}]);
end
fclose(fid);