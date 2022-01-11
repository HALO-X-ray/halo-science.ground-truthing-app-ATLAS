function represent_v2_ground_truths(main_window, v2_gt_exists, v2_gt)
    if v2_gt_exists

        v2_axis = findall(main_window.Children,'Tag','v2_axis');
        hold(v2_axis,'on');
        rectangle(v2_axis,'Position',v2_gt{:},'EdgeColor',[1 0 0],'LineWidth',1.0);
        
        v1_axis = findall(main_window.Children,'Tag','v1_axis');
        hold(v1_axis,'on');
        v1_line_coords = v1_axis.YLim;
        plot([1 1]*v2_gt{1}(1)+5,v1_line_coords,'linestyle','--','Color',[0.8 0.2 0.2 0.4],'Parent',v1_axis);
        plot([1 1]*(v2_gt{1}(1) + v2_gt{1}(3))+5,v1_line_coords,'linestyle','--','Color',[0.8 0.2 0.2 0.4],'Parent',v1_axis);        
    end
end