function close_progress_window(src, ~)

try
    main_window = getappdata(src,'main_window');
    toolbar = findall(main_window.Children,'Tag','toolbar');
    progress_toggle = findall(toolbar.Children);
    
    progress_toggle.State = 'off';
catch
end

    delete(src)

end