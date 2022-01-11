function select_rows_callback(src,event)

progress_window = src.Parent;

%%

progress_table = src.Data;
selected_rows = event.Indices;

rows = unique(selected_rows(:,1));

explosion = zeros(size(progress_table,1),1);
explosion(rows) = 1;


% disp(selected_rows);

pc_axis = findall(progress_window.Children,'Tag','piechart_axis');
delete(pc_axis.Children);
pie_chart = pie(pc_axis,progress_table.scan_number, explosion, progress_table.subject);

[pie_chart(rows*2).FontWeight] = deal('bold');

% disp(pie_chart(rows));




end