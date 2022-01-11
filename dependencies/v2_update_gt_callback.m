function v2_update_gt_callback(src, ~)

    main_window = src.Parent;
    
    image = getappdata(main_window,'v2_image');
    permission_to_write = 1;
    
    ground_truth_table = getappdata(main_window,'ground_truth_table');
    hxt_scan_keys = getappdata(main_window,'hxt_scan_keys');
    counter = findall(main_window.Children,'Tag','index_counter');
    index = counter.Value;
    
    v2_axis = findall(main_window.Children,'Tag','v2_axis');
    ground_truth = drawrectangle(v2_axis);

    updated_ground_truth_position = ground_truth.Position;
    delete(ground_truth)
    
%     update_v2_figure = figure();
%     ax = axes('Parent',update_v2_figure);
%     imshow(image,'Parent',ax);
%     set(ax, 'Layer','top')
%     grid on
%     ground_truth = drawrectangle(ax);
    
    current_scan_key = hxt_scan_keys(index);
    current_scan_key_exists = ismember(current_scan_key,ground_truth_table.scan_key);
    
    if current_scan_key_exists
        
        scan_key_row = ground_truth_table.scan_key == current_scan_key;
        value_already_populated = ~cellfun(@isempty,ground_truth_table(scan_key_row,:).v2_GT_rectangle);
        
        if value_already_populated && all(updated_ground_truth_position ~= 0)
            
            permission_to_write = string(uiconfirm(main_window,'Overwrite Previous Ground Truth','Confirm Close',...
                        'Icon','warning')) == "OK";
                    
        elseif any(updated_ground_truth_position == 0)
            
            permission_to_write = 0;
            
        end
        
    end
    
    if permission_to_write
        
        if current_scan_key_exists
           
            scan_key_row = ground_truth_table.scan_key == current_scan_key;
%             ground_truth_table.v2_GT_rectangle(scan_key_row,:) = {ground_truth.Position};
            ground_truth_table.v2_GT_rectangle(scan_key_row,:) = {updated_ground_truth_position};
        else
            
            scan_key_row = size(ground_truth_table,1) + 1;
            
            ground_truth_table.scan_key(scan_key_row) = current_scan_key;
            
%             ground_truth_table.v2_GT_rectangle(size(ground_truth_table,1),:) = {ground_truth.Position};            
            ground_truth_table.v2_GT_rectangle(scan_key_row,:) = {updated_ground_truth_position};            
            ground_truth_table.is_valid_scan(scan_key_row,:) = 1;            
            
        end
        
        ground_truth_table = update_gt_metadata(ground_truth_table, scan_key_row);
        
        disp("V2 ground truth updated");
        
    else
        
        disp("V2 ground truth update cancelled");        
        
    end
    
    setappdata(main_window,'ground_truth_table',ground_truth_table);
    update_previous_v2_gt_label(main_window, 1, ground_truth_table.v2_GT_rectangle(size(ground_truth_table,1),:));
%     close(update_v2_figure);
    
    data_dir = getappdata(main_window,'data_directory');
    
    tic
    save(fullfile(data_dir,"ground_truths.mat"),'ground_truth_table');
    disp("Ground truths saved. Elapsed time: " + toc + "s");
    
    update_axes_images(main_window);
    render_existing_ground_truths(main_window);
    update_dataset_progress(main_window);
    
end