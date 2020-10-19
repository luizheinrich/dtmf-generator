% =========================================================================
% UNIVERSIDADE FEDERAL DO PARÁ
% INSTITUTO DE TECNOLOGIA
% ENGENHARIA ELÉTRICA
% PROCESSAMENTO DIGITAL DE SINAIS
%
% LUIZ HENRIQUE P. ASSUNÇÃO
% MARCIO GABRIEL BRAGA MUNIZ
% PAULO RONALDO G. P. JUNIOR
% =========================================================================


% Developed by Luiz Henrique P. Assunção
% https://github.com/luizheinrich/dtmf-generator


% Apagar variáveis
clear variables

% Apresentação do programa
fprintf('\n\n');
fprintf('Bem vindo ao Gerador de Tons DTMF');
fprintf('\n\n');

pause(1);

prompt = 'Qual é o seu nome?\n\n--> ';
SeuNome = input(prompt,'s');
fprintf('\n\n');

prompt = 'Qual é o seu numero?\n\n--> ';
SeuNumero = input(prompt);
fprintf('\n\n');

% Chamando a função
MyNumberSong(SeuNome,SeuNumero)


function [] = MyNumberSong(SeuNome,SeuNumero)


% Separador de dígitos
Digit = num2str(SeuNumero) - '0';

% Taxa de amostragem em Hertz/s
fa = 20000;

% 
x  = 0:1/fa:0.08;

% Definindo cada nota
a  = sin(2*pi*1209*x);
a2 = sin(2*pi*1336*x);
a3 = sin(2*pi*1477*x);
b  = sin(2*pi*697*x);
b2 = sin(2*pi*770*x);
b3 = sin(2*pi*852*x);
b4 = sin(2*pi*941*x);

% Som mudo de 80ms
m  = 0*sin(2*pi*0*x);

% Montando as notas  ||  Numero  |  Posição  ||
p  = (a2 + b4);          % -> 0     % -> 1
q  = (a  + b);           % -> 1     % -> 2
w  = (a2 + b);           % -> 2     % -> 3
e  = (a3 + b);           % -> 3     % -> 4
r  = (a  + b2);          % -> 4     % -> 5
t  = (a2 + b2);          % -> 5     % -> 6
y  = (a3 + b2);          % -> 6     % -> 7
u  = (a  + b3);          % -> 7     % -> 8
i  = (a2 + b3);          % -> 8     % -> 9
o  = (a3 + b3);          % -> 9     % -> 10



% Lista com os tons em ordem crescente [ 0, 1, 2, ..., 9 ]
SongList = [p,q,w,e,r,t,y,u,i,o];

% Tamanho do vetor x
LX = length(x);

% Tamanho do vetor Digit
LD = length(Digit);

% Pré-alocando variáveis
SongMaker = zeros(1,LD);
Numero    = zeros(1,2*LX*LD-LX);


% Construtor da sequência de tons
for cont = 1:LD

        % [Array não pode começar em zero]
        % Deslocamento em +1
        RL = Digit(cont) + 1;
        
        % Gravando os tons dos numeros em sequência
        SongMaker(1,((cont-1)*LX + 1):cont*LX) = SongList(1,((RL-1)*LX + 1):RL*LX);

end

ContOdd = 0;

% Intercalador de tons mudos no som construído
for cont2 = 1:2*LD-1

        % Alternador +1 -1
        Odd = (-1)^cont2;
        
        if Odd == -1 % Se for impar -> gravar tom
            
            ContOdd = ContOdd + 1;
            Numero(1,((cont2-1)*LX + 1):cont2*LX) = SongMaker(1,((ContOdd-1)*LX + 1):ContOdd*LX);
            
        else         % Se for par   -> som mudo

            Numero(1,((cont2-1)*LX + 1):cont2*LX) = m(1,1:LX);
            
        end
            
end




% Executar composição sonora
soundsc(Numero,fa)

% Exportar composição sonora
filename = sprintf('%s_dtmfNumber.wav',SeuNome);
audiowrite(filename,Numero,fa);


end