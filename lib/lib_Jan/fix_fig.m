
% new loose insets are -1 (auto) or a number (relative size)
% what can be
%   * 'full' (for images etc., it is assumed that there are no axis at all)
%   * a vector [left bottom right top] of insets (normalized scale), -1 for
%        default
%   * a scalar, in which case it is interpreted as what * [1 1 1 1]
% for colorbar, use [0 0 -1 0]
% sets the renderer to "painters" which produces sane EPS but does not
% handle transparency
function fix_fig(widthheight_pt, what)
    set(gcf, 'Units', 'points');
    set(gcf, 'MenuBar', 'none');
    pos = get(gcf,'Position');
    
    set(gcf, 'Position', [pos(1) pos(2) widthheight_pt]);
    set(gcf, 'PaperUnits', 'points'); % point = 1/72 inch
    set(gcf, 'PaperSize', widthheight_pt);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 widthheight_pt]);
    
    if (isa(what,'char'))
        if (strcmp(what,'full'))
            % no captions, zoom current axis to full size
            set(gca,'LooseInset',[0 0 0 0]); 
            set(gca,'Position',[0 0 1 1]);       
        else
            error('invalid mode');
        end
    else
        if (isscalar(what))
            what = what * [1 1 1 1];
        end
        if (any(size(what) ~= [1 4]))
            error('invalid insets');
        else
            set(gca, 'OuterPosition', [0 0 1 1]);
            drawnow;
            default_insets = get(gca,'LooseInset');
            insets = what;
            insets(insets < 0) = default_insets(insets < 0);
            %set(gca,'LooseInset',insets);
            set(gca,'Units','points');
            sz = get(gcf,'Position');
            
            set(gca,'Position',...
                [insets(1),...
                 insets(2),...
                 sz(3) - insets(1) - insets(3),...
                 sz(4) - insets(2) - insets(4)]);
%            set(gca,'OuterPosition',pos + ...
%                [insets(1) - default_insets(1),...
%                 insets(2) - default_insets(2),...
%                 default_insets(1) + default_insets(3) - insets(1) - insets(3),...
%                 default_insets(2) + default_insets(4) - insets(2) - insets(4)]);
        end
    end

    set(gcf,'renderer','painters');
    set(gca,'Units','normalized'); % back to auto scaling to make it easier to use
    
%    set(gca,'OuterPosition',[0 0 1 1]);
    
    %drawnow; pause(1);
    %for i = 1:5
    %    set(gca,'LooseInset',get(gca,'TightInset'))
    %end
    
    %set(gca,'LooseInset',[0 0 0 0]); 
    %drawnow;
    %set(gcf, '
    %set(gcf, 'PaperPosition', [0 0 192 144]);    

%    set(gca, 'Position', [0 0 1 1]); % this is required to update TightInset    
    % Tightinset = [left bottom right top]
    % Position = [left bottom width height] - all counted from bottom left corner
    %set(gca,'Units','points'); % avoid messed up normalized positioning
    % first resize to fill
    %op = get(gca,'OuterPosition'); ins = get(gca,'TightInset');
    %set(gca, 'OuterPosition', [op(1) op(2) op(3)*( + ...
    %    [0 0 
    %    get(gca, 'TightInset') * [-1 0 0 0; 0 -1 0 0; 1 0 1 0; 0 1 0 1]);    
    
    % for plots with captions    
    %set(gca, 'OuterPosition', [0 0 1 1]);
    %set(gca, 'OuterPosition', get(gca, 'OuterPosition') + get(gca, 'TightInset') * [-1 0 0 0; 0 -1 0 0; 1 0 1 0; 0 1 0 1]);
    
    % set renderer to 'painters' to generate sane EPS 
end
