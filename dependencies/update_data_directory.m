function update_data_directory(main_window, new_directory)

    counter = findall(main_window.Children,'Tag','index_counter');
    counter.Value = 1;
    
    data_directory = new_directory;
    
    data_dir_split = split(data_directory,"\");
    scan_subject = string(data_dir_split{end});

    [~, ~, dx_dir, hxt_scan_keys, timestamps, tdr_number, ground_truth_table] = ...
    initialise_variables_from_directory(data_directory);

    setappdata(main_window,'data_directory',data_directory);
    setappdata(main_window,'scan_keys_master',hxt_scan_keys);
    setappdata(main_window,'hxt_scan_keys',hxt_scan_keys);
    setappdata(main_window,'dx_dir',dx_dir);
    setappdata(main_window,'timestamps',timestamps);
    setappdata(main_window,'ground_truth_table',ground_truth_table);
    setappdata(main_window,'scan_subject',scan_subject);
    
    refresh_display(main_window);
    
%     update_scan_subject_label(main_window);
%     update_scan_key_label(main_window);
%     update_timestamp_label(main_window);
%     update_axes_images(main_window);
%     update_index_counter_limits(main_window,tdr_number);
%     
%     render_existing_ground_truths(main_window)
%     update_dataset_progress(main_window);
    
    
    

    disp("Directory changed to: " + new_directory);


end