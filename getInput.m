
function val = getInput(p,t,d)
s = {};
while size(s)==0
    prompt = {sprintf('%s',p)};
    dlg_title = t;
    num_lines = 1;
    def = {sprintf('%s',d)};
    options.Resize='on';
    options.WindowStyle='normal';
    s = inputdlg(prompt,dlg_title,num_lines,def,options);
end
val = str2double(s{1});
end