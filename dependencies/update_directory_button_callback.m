function update_directory_button_callback(src,~)

    main_window = src.Parent;
    directory_field = findall(main_window.Children,'Tag', 'directory_field');
    new_directory = uigetdir("G:\Shared drives\Data_ATLAS_Edge\Edge-ATR Live Data\Edge 1.08");

    if new_directory ~= 0
        
        update_data_directory(main_window,new_directory);
        directory_field.Value = new_directory;
        
    end
    

end