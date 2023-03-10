clear
inphase = [-7/2 -7/2 -5/2 -5/2 -3/2 -3/2 -1/2 -1/2 1/2 1/2 3/2 3/2 5/2 5/2 7/2 7/2];
quadr = [-1/2 -5/2 -3/2 -7/2 -1/2 -5/2 -3/2 -7/2 7/2 3/2 5/2 1/2 7/2 3/2 5/2 1/2];
inphase = inphase(:);
quadr = quadr(:);
const = inphase + quadr*j;
scatterplot(const,1,0,'*');
grid on;