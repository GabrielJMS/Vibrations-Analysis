load('MACHINE_HEMBRUG_030_ESSAI03.mat')
% X =  DADOS DO ACELEROMETRO
% Ne = NUMERO DE DADOS DO ENSAIO
% Fe = frequencia de amostragem utilisada no ensaio
%dur = 500; % caso queira especificar uma dura��o especifica do ensaio em s
dur = double(Ne)/double(Fe); % duree de la fenetre d'analysis en secondes (analisa tudo) 
w = 1024; % numero de point a chaque delta t
N = dur*Fe; %quantit� d'echantillon de la fenetre d'analisys
x = X(1:N); %fenetre d'analisys
%t = time(1:N); %fenetre d'analisys
shift = 0; %caso queira fazer superposi��o dos dados entre cada fft %entrez une valeur n�gative pour le chevauchement ou z�ro pour la discr�tisation normale

nt = N/(w + shift); % nombre de points de la discr�tisation
if floor(nt)~= nt
    nt = floor(nt);
    N = (nt)*(w + shift);
    dur = N/Fe;
    x = X(1:N); %fenetre d'analisys
end

nf = w/2+1; %nombre de points des frequences
SOG = zeros(nf,nt);
j = 1;

for i=0:1: nt-1
    indx = i*(w + shift);
    xt = x(indx+1:indx+w);
    TSOG = abs(fft(xt/w)); %vecteur temporaire d'amplitude
    TSOG = TSOG(1:w/2+1);  % r�duction par 2 du vecteur spectrale (sym�trie Hermitienne)
    TSOG=log(1E-6+TSOG);
    %TSOG(2:end-1) = 2*TSOG(2:end-1);
    SOG(:,j) = TSOG; %stocke les amplitudes des fr�quences en chaque instant de temp
    j=j+1;  
end
%%

f = Fe*(0:(w/2))/w; %vecteur de frequence
temp = linspace(0, dur, nt); %vecteur de temp

figure(1)
imagesc(temp, f, SOG)
ax = gca; % current axes
ax.YDir = 'normal'; %direction ascendante de bas en haut
title('MACHINE HEMBRUG 030 ESSAI01')
ylabel('Fr�quence [Hz]')
xlabel('Temps [s]')
colormap jet
colorbar
%%
figure(2)
plot(time,X)
ylabel('Acc�l�ration [m/s^2]')
xlabel('Temps [s]')