

s8 = 0; %skip scene 8
s12 = 0;

s35 = 0; %skip scene 35
%s44 = 0; %skip scene 44

path_single = '../Data/SingleObject/';
path_multi = '../Data/MultipleObjects/';

%% Hat
if ~exist('s6', 'var')
    scene = 6;
    frames = [1, 120, 220, 300, 390];
    PC = extractObjects(scene, frames, path_single);
    s6 = struct('Label', 'Hat', 'Model', PC);
    save('objLib/s6.mat', 's6');
    drawModel(s6.Model, s6.Label);
end

%% Pringles
if ~exist('s8', 'var')
    scene = 8;
    frames = [1, 120, 220, 350, 460];
    PC = extractObjects(scene, frames, path_single);
    s8 = struct('Label', 'Pringles', 'Model', PC);
    save('objLib/s8.mat', 's8');
    drawModel(s8);
end

%% Penguin
if ~exist('s12', 'var')
    scene = 12;
    frames = [1, 90, 180, 170, 372];
    PC = extractObjects(scene, frames, path_single);
    s12 = struct('Label', 'Penguin', 'Model', PC);
    save('objLib/s12.mat', 's12');
    drawModel(s12);
end


%% Scene 35
if ~exist('s35', 'var')
    scene = 35;
    frames = [1, 50, 100]; %, 330, 468
    PC = extractObjects(scene, frames, path_multi);
    s35 = struct('Label', 'Scene 35', 'Model', PC);
    save('sceneLib/s35.mat', 's35');
    drawModel(s35);
end

%% Scene 44
if ~exist('s44', 'var')
    scene = 44;
    frames = [1, 110, 220, 330, 440, 556];
    PC = extractObjects(scene, frames, path_multi);
    s44 = struct('Label', 'Multi 44', 'Model', PC);
    save('sceneLib/s44.mat', 's44');
    drawModel(s44.Model, 'Scene 44');
end