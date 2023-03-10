clear
% �������� ������� �����, �������������� �������� ���������
inphase = [-7/2 -7/2 -5/2 -5/2 -3/2 -3/2 -1/2 -1/2 1/2 1/2 3/2 3/2 5/2 5/2 7/2 7/2];
quadr = [-1/2 -5/2 -3/2 -7/2 -1/2 -5/2 -3/2 -7/2 7/2 3/2 5/2 1/2 7/2 3/2 5/2 1/2];
inphase = inphase(:);
quadr = quadr(:);
const = inphase + quadr*j;

EbNoVec = [-2:1:20];

steps=1e7;
SERVec_PSK = [];
load_system('compare_PSK.mdl');
opts = simset('SrcWorkspace','Current','DstWorkspace','Current');
set_param('compare_PSK/AWGN Channel PSK','EsNodB','EbNodB+10*log10(4)');
set_param('compare_PSK/Error Rate Calculation PSK','numErr','1e4');
set_param('compare_PSK/Error Rate Calculation PSK','maxBits','steps');

for n = 1:length(EbNoVec)
    fprintf (1,'��������� %2d ������ �� %d\n',n,length(EbNoVec));
    EbNodB = EbNoVec(n);
    sim('compare_PSK',steps,opts);
    SERVec_PSK(n,:) = PSK_SER;    
    semilogy(EbNoVec(n),SERVec_PSK(n,1),'go-');
    hold on;
    drawnow;
end

hold off;

% �������� ����������, ����������� ��� ���������� Q-�������
a = 1;          % 1/2 ������� ����������, ����� ������� (1,1) � (1,-1), ��������
b = sqrt(2)/2;  % 1/2 ������� ����������, ����� ������� (-3,0) � (-2,1), ��������
c = sqrt(5)/2;  % 1/2 �������� ����������, ����� ������� (-1,3) � (0,5), ��������        
d = 0.5;        % 1/2 ���������� ����������, ����� ������� (1,1) � (2,1), ��������

% ������ ������� ��������
A = sqrt(sum(abs(const).^2)/length(const));

% Q(z) = 0.5*erfc(z/sqrt(2)) - ���� z ��� ������ �������� ����������
za = a/A*sqrt(2*4*(10.^(EbNoVec./10)));
zb = b/A*sqrt(2*4*(10.^(EbNoVec./10)));
zc = c/A*sqrt(2*4*(10.^(EbNoVec./10)));
zd = d/A*sqrt(2*4*(10.^(EbNoVec./10)));

% ����������� ������ ��� ������� ���� ����� (����� �����, � �������
% ��������� ����� � ������������ �������� �����) 
P1 = 2*0.5*erfc(zc/sqrt(2));
P2 = 2*0.5*erfc(zc/sqrt(2)) + 2*0.5*erfc(za/sqrt(2));
P3 = 2*0.5*erfc(zc/sqrt(2)) + 1*0.5*erfc(za/sqrt(2)) + 1*0.5*erfc(zd/sqrt(2))+ 1*0.5*erfc(zb/sqrt(2));
P4 = 2*0.5*erfc(zb/sqrt(2)) + 2*0.5*erfc(zc/sqrt(2));
P5 = 3*0.5*erfc(za/sqrt(2)) + 2*0.5*erfc(zc/sqrt(2)) + 1*0.5*erfc(zd/sqrt(2));

% ������� ����������� ������
BER_PSK_16_an=(2*P1 + 4*P2 + 4*P3 + 2*P4 + 4*P5) / 16;

semilogy(EbNoVec,SERVec_PSK(:,1),'go',EbNoVec,BER_PSK_16_an,'mx:','LineWidth',1.2);
set(gca, ...
'XAxisLocation','bottom', ...
'XTickMode','auto', ...
'YTickMode','auto', ...
'FontSize',14, ...
'FontName','Arial Unicode MS', ...
'Box','on');
legend('PSK sim','PSK analit');
grid off;
xlabel('Eb/No (dB)','FontSize',14); ylabel('SER','FontSize',14);
hold off;