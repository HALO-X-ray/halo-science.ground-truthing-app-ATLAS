function ground_truth_table = update_gt_metadata(ground_truth_table, scan_key_row)

    ground_truth_table.user_id(scan_key_row) = string(getenv('username'));
    current_timestamp = datetime('now','Format','yyyy-MM-dd_HH:mm:ss');
    ground_truth_table.timestamp(scan_key_row) = current_timestamp;
    
end