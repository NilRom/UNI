function [df_shifted] = shift_exo(df,plotIt)
%SHIFT_EXO Summary of this function goes here
%   Detailed explanation goes here
testdf = df;
og_stu = df.tp_stu;
interpolated = mod(testdf.hour,3) ~= 1;
testdf.tp_vxo(interpolated) = nan;
testdf.tp_stu(interpolated) = nan;
testdf.tp_stu = fillmissing(testdf.tp_stu,"previous");
testdf.tp_vxo = fillmissing(testdf.tp_vxo,"previous");

shift = 3;
shiftedStu = testdf.tp_stu(1+shift:end);
shiftedVxo = testdf.tp_vxo(1+shift:end);


zeropad = zeros(length(df.t_sla)-length(shiftedStu),1);
shiftedVxo = vertcat(shiftedVxo,zeropad);
shiftedStu = vertcat(shiftedStu,zeropad);
df.tp_stu = shiftedStu;
df.tp_vxo = shiftedVxo;
df_shifted = df;
if plotIt == 1

    f = figure;
    newcolors = ["#0072BD","#D95319","#77AC30"];
    colororder(newcolors);
    f.Position = [100 100 1000 800];
    set(f,'DefaultLineLineWidth',2)
    plot(testdf.time(12000:12100),testdf.t_sla(12000:12100))
    hold on
    plot(testdf.time(12000:12100),df.tp_stu(12000:12100))
    plot(testdf.time(12000:12100), og_stu(12000:12100))
    
    legend(["Svedala temp", "Sturup pred shifted", "Sturup pred Original"])
    ylabel("°C")
end

end

