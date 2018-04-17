function r=powerLawDistribution(columns, rows, minVal,power)
y=rand(columns,rows);
r = ( -1*(minVal^(power+1))*y + minVal^(power+1)).^(1/(power+1));
end