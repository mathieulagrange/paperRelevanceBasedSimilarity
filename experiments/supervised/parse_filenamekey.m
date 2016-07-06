function sorted_folds = parse_filenamekey(filenamekey_path)
%%
table = readtable(filenamekey_path);
fold_strs = table2cell(table(:,1));
folds = cellfun(@(x) str2num(x(5)), fold_strs);
name_strs = table2cell(table(:,4));
[sorted_names, sorting_indices] = sort(name_strs);
sorted_folds = folds(sorting_indices)
end