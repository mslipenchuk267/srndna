
% 18 blocks
pre_block_ITI = [repmat(8,1,9) repmat(10,1,6) repmat(12,1,3)]; % some IBI jitter to estimate Fair/Unfair separately (HCP is fixed at 15 s)
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


fid = fopen('UG_design_test.csv','w');
fprintf(fid,'Trialn,Blockn,Partner,IsFairBlock,Offer,ITI\n');

nblocks = length(block_types);
rand_trials = randperm(nblocks);
t = 0;
for i = 1:nblocks
    % Partner is Friend=3, Stranger=2, Computer=1
    % "Feedback" is the offer value (out of $20)
    
    % start with 20
    fair = [10 9 8 7];
    unfair = [1 2 3 4];
    neutral = [5 6];
    
    unfair_block = [randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(fair,1) randsample(neutral,1)];
    unfair_block = unfair_block(randperm(length(unfair_block)));
    fair_block = [randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(unfair,1) randsample(neutral,1)];
    fair_block = fair_block(randperm(length(fair_block)));
    
    switch block_types(i)
        case 1 %Computer Unfair
            partner = 1;
            feedback_mat = unfair_block;
            isfair = 0;
        case 2 %Computer Fair
            partner = 1;
            feedback_mat = fair_block;
            isfair = 1;
        case 3 %Stranger Unfair
            partner = 2;
            feedback_mat = unfair_block;
            isfair = 0;
        case 4 %Stranger Fair
            partner = 2;
            feedback_mat = fair_block;
            isfair = 1;
        case 5 %Friend Unfair
            partner = 3;
            feedback_mat = unfair_block;
            isfair = 0;
        case 6 %Friend Fair
            partner = 3;
            feedback_mat = fair_block;
            isfair = 1;
    end
    
    %fprintf(fid,'Trialn,Blockn,Partner,IsFairBlock,Offer,ITI\n');
    for f = 1:length(feedback_mat)
        t = t + 1;
        if f == length(feedback_mat)
            fprintf(fid,'%d,%d,%d,%d,%d,%d\n',t,i,partner,isfair,feedback_mat(f),pre_block_ITI(i));
        else
            fprintf(fid,'%d,%d,%d,%d,%d,%d\n',t,i,partner,isfair,feedback_mat(f),1);
        end
    end
end
fclose(fid);


