function refresh_callback(src,~)

    main_window = src.Parent;
    counter = findall(main_window.Children,'Tag','index_counter');
    data_directory = getappdata(main_window,'data_directory');

    [~, ~, dx_dir, hxt_scan_keys, timestamps, ~, ground_truth_table] = ...
    initialise_variables_from_directory(data_directory);

    setappdata(main_window,'hxt_scan_keys',hxt_scan_keys);
    setappdata(main_window,'dx_dir',dx_dir);
    setappdata(main_window,'timestamps',timestamps);
    setappdata(main_window,'ground_truth_table',ground_truth_table);
    
    tdr_number = length(hxt_scan_keys);
    
    if counter.Value > tdr_number
        counter.Value = tdr_number;
    end
    
    update_scan_key_label(main_window);
    update_timestamp_label(main_window);
    update_axes_images(main_window);
        
    render_existing_ground_truths(main_window)
    
    disp('Directory refreshed');

end