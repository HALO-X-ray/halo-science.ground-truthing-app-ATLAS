function v2_clear_gt_callback(src, ~)

    main_window = src.Parent;
    
    permission_to_clear = 0;
    
    ground_truth_table = getappdata(main_window,'ground_truth_table');
    hxt_scan_keys = getappdata(main_window,'hxt_scan_keys');
    counter = findall(main_window.Children,'Tag','index_counter');
    index = counter.Value;
    
    current_scan_key = hxt_scan_keys(index);
    current_scan_key_exists = ismember(current_scan_key,ground_truth_table.scan_key);
    
    if current_scan_key_exists
        scan_key_row = ground_truth_table.scan_key == current_scan_key;
        value_already_populated = ~cellfun(@isempty,ground_truth_table(scan_key_row,:).v2_GT_rectangle);
        
        if value_already_populated
            
            permission_to_clear = string(uiconfirm(main_window,'Clear Current Ground Truth?','Confirm Close',...
                        'Icon','warning')) == "OK";
            
        end
        
    end
    
    
    if permission_to_clear
        
        if current_scan_key_exists
           
            scan_key_row = ground_truth_table.scan_key == current_scan_key;
            ground_truth_table.v2_GT_rectangle(scan_key_row,:) = {[]};          
            
        end
        
    end
    
    empty_rows = cellfun(@isempty,ground_truth_table.v1_GT_rectangle) & cellfun(@isempty,ground_truth_table.v2_GT_rectangle);
    ground_truth_table(empty_rows,:) = [];
        
    setappdata(main_window,'ground_truth_table',ground_truth_table);
    update_previous_v2_gt_label(main_window, 0, []);
    
    data_dir = getappdata(main_window,'data_directory');
    
    tic
    save(fullfile(data_dir,"ground_truths.mat"),'ground_truth_table');
    disp("V2 ground truth saved. Elapsed time: " + toc + "s");
        
    update_axes_images(main_window);
    render_existing_ground_truths(main_window);
    update_dataset_progress(main_window);

end