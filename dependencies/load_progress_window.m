function load_progress_window(src, ~)
    
    main_window = src.Parent.Parent;
%%
    window_buffer = 120;
    progress_window = uifigure(main_window,'Position', get(0,'screensize') + window_buffer*[1 1 -2 -2],...
        'CloseRequestFcn', @close_progress_window, 'Name', 'Dataset Breakdown',...
        'Icon', "G:\Shared drives\Software\MAT - MATLAB\m files\git repos\halo-science.ground-truthing-app\dependencies\halo+symbol.png");
    setappdata(progress_window,'main_window',main_window);
    progressbar = uiprogressdlg(progress_window, 'Title', 'Please Wait',...
        'Message', 'Loading ground truthing progress');

    root_dir_path = getappdata(main_window,'data_directory');
    root_dir_path = split(root_dir_path,'\');
    root_dir_path = string(join(root_dir_path(1:end-1),'\'));
    
    root_dir = dir(root_dir_path);
    root_dir = root_dir(vertcat(root_dir.isdir));
    
%     disp(root_dir_path);
    ignored_directories = string(importdata(fullfile(root_dir_path,"gt.ignore.txt")));
    
    root_dir(ismember(string({root_dir.name}), ignored_directories) ) = [];
    
    material_subfolders = string({root_dir.name})';
    
    %
    
    progress_table = table();
    
    for subfolder_index = 1:length(material_subfolders)
        
        progress_table.subject(subfolder_index) = material_subfolders(subfolder_index);
        progress_table.scan_number(subfolder_index) = 0;
        progress_table.progress(subfolder_index) = 0;
        progress_table.contributors(subfolder_index) = "Unknown";
        progress_table.dates_worked(subfolder_index) = "Unknown";
        
        ground_truth_path = fullfile(root_dir_path,...
            material_subfolders(subfolder_index),...
            "ground_truths.mat");
        
        ground_truths_exist = exist(ground_truth_path, 'file') == 2;
        
        if ground_truths_exist
            
            load(ground_truth_path,'ground_truth_table');
            ground_truth_table_info = ground_truth_table.Properties.VariableNames;
            scan_valid_field_exists = ismember("is_valid_scan",ground_truth_table_info);
            contributor_field_exists = ismember("user_id", ground_truth_table_info);
            timestamp_field_exists = ismember("timestamp", ground_truth_table_info);
            
            
            tdr_dir = dir(fullfile(root_dir_path,...
            material_subfolders(subfolder_index),"*.tdr.dcs"));
            hxt_scan_keys = reduce_filename_to_identifier(string({tdr_dir.name}));

            if scan_valid_field_exists
                
                invalid_rows = ground_truth_table.is_valid_scan == 0;
            
            else
                
                invalid_rows = false(size(ground_truth_table,1),1);
                
            end
            
            completed_rows = ~(cellfun(@isempty,ground_truth_table.v1_GT_rectangle) | cellfun(@isempty,ground_truth_table.v2_GT_rectangle));
            completed_scan_keys = string(ground_truth_table.scan_key(completed_rows | invalid_rows));

            proportion = sum(ismember(completed_scan_keys,hxt_scan_keys))/length(unique(hxt_scan_keys));

            progress_table.progress(subfolder_index) = round(100*proportion,3);
            
            progress_table.scan_number(subfolder_index) = length(unique(hxt_scan_keys));
            
            if contributor_field_exists
                progress_table.contributors(subfolder_index) = join(unique(ground_truth_table.user_id),',');
            end
            
            if timestamp_field_exists
                timestamps = ground_truth_table.timestamp;
                dates = datetime(timestamps,'InputFormat','yyyy-MM-dd_HH:mm:ss','Format','yyyy-MM-dd');
                dates = join(unique(string(dates)),',');
                progress_table.dates_worked(subfolder_index) = dates;
            end
            
        end
        
        progressbar.Value = subfolder_index/length(material_subfolders);
        drawnow();
%         pause(0.01);
    end
    
    delete(progressbar);
    
    %
    
    uiimage(progress_window, 'ImageSource', "C:\Users\Liam\Pictures\ground truthing.png",...
        'Position', nonnormalised_size(progress_window, [0.005 0.9 0.08 0.08]), 'Tag', 'icon_image');
    
    vars = {'Material','Number of Scans','Completion Percentage','People Ground Truthing','Dates Worked'};
    
    uitable(progress_window,...
        'Units','normalized','Position',[0.02 0.05 0.47 0.8],...
        'Data',progress_table, 'Tag', 'display_table',...
        'ColumnName',vars, 'SelectionType', 'row', 'MultiSelect', 'on',...
        'CellSelectionCallback', @select_rows_callback);
    
    uilabel(progress_window,'Position',nonnormalised_size(progress_window, [0.09 0.9 0.1 0.1]),...
        'Text',"Total Number of Scans: " + string(sum(progress_table.scan_number)));
    uilabel(progress_window,'Position',nonnormalised_size(progress_window, [0.09 0.87 0.2 0.1]),...
        'Text',"Unique Scan Configurations: " + string(size(progress_table, 1)));
    
    valid_progress_table = progress_table(~isnan(progress_table.progress),:);
    
    uilabel(progress_window,'Position',nonnormalised_size(progress_window, [0.09 0.84 0.25 0.1]),...
        'Text',"Total Ground Truth Completion: " + ...
        string(sum((valid_progress_table.scan_number .* valid_progress_table.progress)/...
        sum(valid_progress_table.scan_number))) + "%");
    
    pc_axis = uiaxes(progress_window,...
        'Units','normalized','Position',[0.465 0.2 0.51 0.65],...
        'tag','piechart_axis');
    
    pie(pc_axis,progress_table.scan_number, progress_table.subject);
    title(pc_axis,'Dataset Composition','position',[-1 1.35]);
    
        
    
    
end