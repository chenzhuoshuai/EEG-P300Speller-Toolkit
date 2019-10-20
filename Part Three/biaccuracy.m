%% 二分正确率类测试脚本
accurate=0;
for i=1:15300
   if output_final(i)==biclass_labelset(i)
       accurate=accurate+1;
   end
end
accurate/15300
% for i=1:15300
%    if output(i)==biclass_labelset(i)
%        accurate=accurate+1;
%    end
% end
% accurate/15300