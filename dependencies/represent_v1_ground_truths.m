function represent_v1_ground_truths(main_window, v1_gt_exists, v1_gt)
    if v1_gt_exists

        v1_axis = findall(main_window.Children,'Tag','v1_axis');
        hold(v1_axis,'on');
        rectangle(v1_axis,'Position',v1_gt{:},'EdgeColor',[1 0 0],'LineWidth',1.0);            

        v2_axis = findall(main_window.Children,'Tag','v2_axis');
        hold(v2_axis,'on');
        v2_line_coords = v2_axis.YLim;
        plot([1 1]*v1_gt{1}(1) - 5,v2_line_coords,'linestyle','--','Color',[0.8 0.2 0.2 0.4],'Parent',v2_axis);
        plot([1 1]*(v1_gt{1}(1) + v1_gt{1}(3)) - 5,v2_line_coords,'linestyle','--','Color',[0.8 0.2 0.2 0.4],'Parent',v2_axis);
        
    end
end