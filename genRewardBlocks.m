
%{

block per run? probably 12 to have 2 of each condition.
trials per block: 8
length of a trial: 3.5 (details below)

from Barch 2013:

The ??? is presented for up to 1.5 s (if the participant responds before 1.5 s, a
fixation cross is displayed for the remaining time), following by feedback
for 1.0 s. There is a 1.0 s ITI with a ?+? presented on the screen.
The task is presented in blocks of 8 trials that are either mostly reward
(6 reward trials pseudo randomly interleaved with either 1
neutral and 1 loss trial, 2 neutral trials, or 2 loss trials) or mostly
loss (6 loss trials interleaved with either 1 neutral and 1 reward
trial, 2 neutral trials, or 2 reward trials).

three partners: computer, stranger, neutral
two conditions: reward/punishment

guess_dur = 1.5; %could be too fast for older adults
ITI_dur = 1;
feedback_dur = 1;


%}



% 18 blocks
pre_block_ITI = [repmat(8,1,9) repmat(10,1,6) repmat(12,1,3)]; % some IBI jitter to estimate reward/punishment separately (HCP is fixed at 15 s)
pre_block_ITI = pre_block_ITI(randperm(length(pre_block_ITI)));
% this occurrs every 8 trials, starting with trial 1. it should come first
% need to add at least 12 s at the end of the experiment to catch last HRF


block_types = [1:6 1:6 1:6]; %will name these below. 3 partners * 2 outcomes
block_types = block_types(randperm(length(block_types)));
keep_checking = 1;
while keep_checking
    repeats = 0;
    block_types = block_types(randperm(length(block_types)));
    for i = 1:length(block_types)-1
        if block_types(i) == block_types(i+1)
            repeats = repeats + 1;
        end
    end
    if ~repeats
        keep_checking = 0;
    end
end



fid = fopen('SharedReward_design.csv','w');
fprintf(fid,'Trialn,Blockn,BlockType,Partner,Feedback,ITI\n');

nblocks = length(block_types);
rand_trials = randperm(nblocks);
t = 0;
for i = 1:nblocks
    % Partner is Friend=3, Stranger=2, Computer=1
    % Feedback is Reward=3, Neutral=2, Punishment=1
    
    punishment = [1 1 1 1 1 1 randsample([2 3],1) randsample([2 3],1)];
    punishment = punishment(randperm(length(punishment)));
    reward = [3 3 3 3 3 3 randsample([2 1],1) randsample([2 1],1)];
    reward = reward(randperm(length(reward)));
    
    switch block_types(i)
        case 1 %Computer Punishment
            partner = 1;
            feedback_mat = punishment;
        case 2 %Computer Reward
            partner = 1;
            feedback_mat = reward;
        case 3 %Stranger Punishment
            partner = 2;
            feedback_mat = punishment;
        case 4 %Stranger Reward
            partner = 2;
            feedback_mat = reward;
        case 5 %Friend Punishment
            partner = 3;
            feedback_mat = punishment;
        case 6 %Friend Reward
            partner = 3;
            feedback_mat = reward;
    end
    
    for f = 1:length(feedback_mat)
        t = t + 1;
        if f == length(feedback_mat)
            fprintf(fid,'%d,%d,%d,%d,%d,%d\n',t,i,block_types(i),partner,feedback_mat(f),pre_block_ITI(i));
        else
            fprintf(fid,'%d,%d,%d,%d,%d,%d\n',t,i,block_types(i),partner,feedback_mat(f),1);
        end
    end
end
fclose(fid);


