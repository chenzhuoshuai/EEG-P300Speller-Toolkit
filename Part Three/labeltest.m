%% 测试分类器性能 使用的是max2 out of 12
accurate=0;
for i=1:15300
   if output_final(i)==biclass_labelset(i)
       accurate=accurate+1;
   end
end
accurate/15300