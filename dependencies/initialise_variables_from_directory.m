function [tdr_dir, hxt_dir, dx_dir, hxt_scan_keys, timestamps, tdr_number, ground_truth_table] = ...
    initialise_variables_from_directory(data_directory)

    tdr_dir = dir(fullfile(data_directory,"*.tdr.dcs"));
    hxt_dir = dir(fullfile(data_directory,"*.hxt"));
    dx_dir = dir(fullfile(data_directory,"*.dx.dcs"));

    hxt_scan_keys = reduce_filename_to_identifier(string({tdr_dir.name}));
    timestamps = reduce_filename_to_timestamps(string({tdr_dir.name}));
    tdr_number = length(tdr_dir);

    if exist(fullfile(data_directory,"ground_truths.mat"),'file') == 2
        
        tic
        load(fullfile(data_directory,"ground_truths.mat"),'ground_truth_table');
        disp("Existing ground truths loaded, load time: " + num2str(toc) + "s");

    else

        ground_truth_table = table('Size',[0 3],'VariableTypes',{'string','cell','cell'},'VariableNames',{'scan_key','v1_GT_rectangle','v2_GT_rectangle'});
        disp('New ground truth table created');

    end

    scan_valid_field_exists = ismember("is_valid_scan",ground_truth_table.Properties.VariableNames);
    user_id_field_exists = ismember("user_id",ground_truth_table.Properties.VariableNames);
    timestamp_field_exists = ismember("timestamp",ground_truth_table.Properties.VariableNames);
    
    if ~scan_valid_field_exists
        
        ground_truth_table.is_valid_scan = true(size(ground_truth_table,1),1);
        disp("Scan Validity field added to GT table");
        
    end
    
    if ~user_id_field_exists
        
        ground_truth_table.user_id = repelem(string(getenv('username')),size(ground_truth_table,1),1);
        disp("User ID field added to GT table");
        
    end
    
    if ~timestamp_field_exists
        
        current_timestamp = datetime('now','Format','yyyy-MM-dd_HH:mm:ss');
        ground_truth_table.timestamp = repelem(current_timestamp,size(ground_truth_table,1),1);
        disp("Timestamp field added to GT table");
        
    end
    
    tic
    save(fullfile(data_directory,"ground_truths.mat"),'ground_truth_table');
    disp("Ground truths saved. Elapsed time: " + toc + "s");
    

end
