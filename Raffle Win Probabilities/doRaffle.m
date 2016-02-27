taken = [12 21 25 47 6 7 59 69 11 88 13 27 5 16 19 22 33 77 64 3 8 17 20 29 2 26 24 100 70 52 4];
mine = [28 31 90];
numbers = 1:100;
taken = [taken mine];
maximum_number_of_redraws = length(numbers)-length(taken) + 1;


fprintf('Computing the probabilities to win a raffle with %d numbers which you claimed %d of total claimed %d...\n', length(numbers), length(mine), length(taken))

%% PROBABILISTIC CHANCES OF WIN
% Redoes the raffle when an unclaimed number is picked
% Assumes the unclaimed number is put back into the bag and could be picked again
raffleCount = 1:maximum_number_of_redraws;
pRedraw = (length(numbers)-raffleCount+1-length(taken))./(length(numbers)-raffleCount+1);
pSingleDraw = length(taken)./(length(numbers)-raffleCount+1);
pNotWinning = (length(taken)-length(mine))./length(taken);
pWinning = length(mine)./length(taken);
pWin = pRedraw.^(raffleCount-1).*pSingleDraw.*pWinning;
theoreticalPwin = sum(pWin);
fprintf('Theoretical probability of winning: %.2f%%\n', theoreticalPwin*100)


%% STATISTICAL CHANCES OF WIN
% Redoes the raffle when an unclaimed number is picked
% Takes into account that a number is discarded when an unclaimed number is picked
numIwon = 0;
numRaffles = 128e3;
numRedraws = zeros(maximum_number_of_redraws, 1);
remainingNumbers = numbers;
fprintf('Now wait a little bit until we simulate some draws...\n')
for numRaffle = 1:numRaffles
    numberIndex = floor(length(remainingNumbers)*rand)+1;
    raffleNumber = remainingNumbers(numberIndex);
    raffleIndex = find( taken == raffleNumber  );
    redrawCount = 0;
    while isempty(raffleIndex)
        remainingNumbers(numberIndex) = [];
        numberIndex = floor(length(remainingNumbers)*rand)+1;
        raffleNumber = remainingNumbers(numberIndex);
        raffleIndex = find( taken == raffleNumber  );
        redrawCount = redrawCount + 1;
    end
    numRedraws(redrawCount+1) = numRedraws(redrawCount+1) + 1;
    iwon = ~isempty(find(raffleNumber == mine, 1)); 
    if iwon
        numIwon = numIwon + 1;
    end
end
fprintf('Statistical probability of winning: %.2f%%\n', numIwon*100/numRaffles)

maxRedraws = find( numRedraws ~= 0 , 1, 'last' );
bar(0:maxRedraws-1, numRedraws(1:maxRedraws)/numRaffles)
set(gca,'YScale','log')
title(sprintf('Statistical Number of Redraws in %3.2e Trials', numRaffles))
xlabel('Number of Redraws')
ylabel('Occurrence (normalized to 1)')
