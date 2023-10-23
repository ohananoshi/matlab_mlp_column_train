% MATLAB: R2023a

bias = -1;
taxa_de_aprendizado = 0.5;


% DADOS
sample_count_2 = 310;
database = zeros(8,310);
database(:,:) = fscanf(fopen("column_3C.dat","r"),"%f %f %f %f %f %f %c%c", [8, inf]);
database(7:8, : ) = [];

% CONVERTENDO DH,SL E NO EM (0,0,1), (0,1,0) E (1,0,0) RESPECTIVAMENTE
saida_esperada = [zeros(1,210) ones(1,100); zeros(1,60) ones(1,150) zeros(1, 100); ones(1,60) zeros(1,250)];

% MATRIZES DE TREINAMENTO

entrada_treinamento = [database(:,1:42) database(:,61:165) database(:,211:280)];
saida_treinamento = [saida_esperada(:,1:42) saida_esperada(:,61:165) saida_esperada(:,211:280)];

ordem_treinamento = randperm(217);

entrada_misturada(:,:) = entrada_treinamento(:,ordem_treinamento);
saida_misturada(:,:) = saida_treinamento(:,ordem_treinamento);

% GERAÇÃO E TREINAMENTO DA REDE

rede = feedforwardnet([6 3], 'trainlm');
rede = train(rede, entrada_misturada, saida_misturada);

% TESTE

% MATRIZES DE TESTE

entrada_teste = [database(:,43:60) database(:,166:210) database(:,281:310)];
saida_teste = [saida_esperada(:,43:60) saida_esperada(:,166:210) saida_esperada(:,281:310)];

acertos = 0;
acerto_medio = 0;
permutacoes_qtd = 10;
for i = 1:permutacoes_qtd
    ordem_teste = randperm(93);

    entrada_teste_misturada(:,:) = entrada_teste(:,ordem_teste);
    saida_teste_misturada(:,:) = saida_teste(:,ordem_teste);

    y_teste = rede(entrada_teste_misturada);

    for j = 1:93
        acertos = acertos + max_indice_compara(y_teste(:,j), saida_teste_misturada(:,j));
    end

    acerto_medio = acerto_medio + acertos;
    acertos = 0;

end

fprintf("acerto medio: %f \n", (acerto_medio/(permutacoes_qtd*93))*100);

% ====================== FUNÇÕES =====================

% FUNÇÃO PARA VERIFICAR SE O VALOR MAXIMO DA SAIDA ESPERADA
% E O VALOR MAXIMO DA SAIDA DA REDE ESTÃO NO MESMO INDICE
function confirma_indice = max_indice_compara(vetor_a, vetor_b)
    indice_a = find(vetor_a == max(vetor_a));
    indice_b = find(vetor_b == max(vetor_b));

    if indice_a == indice_b
        confirma_indice = 1;
    else
        confirma_indice = 0;
    end
end