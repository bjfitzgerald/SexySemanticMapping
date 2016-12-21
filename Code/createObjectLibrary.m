
s0 = 0;
s2 = 1;
s6 = 0;
s8 = 0; %skip scene 8
%s12 = 0;

s35 = 0; %skip scene 35
s40 = 0;
s44 = 0; %skip scene 44

path_single = '../Data/SingleObject/';
path_multi = '../Data/MultipleObjects/';

%% Iron
if ~exist('s0', 'var')
    scene = 0;
    frames = [1, 120, 220, 300, 390];
    PC = extractObjects(scene, frames, path_single, 300, 1000);
    s0 = struct('Label', 'Iron', 'Model', PC);
    save('objLib/s0.mat', 's0');
    drawModel(s0.Model, s0.Label);
end

%% Bear
if ~exist('s2', 'var')
    scene = 2;
    frames = [1, 100, 200, 300, 376];
    PC = extractObjects(scene, frames, path_single, 300, 1000);
    s2 = struct('Label', 'Bear', 'Model', PC);
    save('objLib/s2.mat', 's2');
    drawModel(s2.Model, s2.Label);
end

%% Hat
if ~exist('s6', 'var')
    scene = 6;
    frames = [1, 120, 220, 300, 390];
    PC = extractObjects(scene, frames, path_single, 300, 500);
    s6 = struct('Label', 'Hat', 'Model', PC);
    %save('objLib/s6.mat', 's6');
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

%% Scene 40
if ~exist('s40', 'var')
    scene = 40;
    frames = [1, 110, 220, 330, 440, 528];
    PC = extractObjects(scene, frames, path_multi);
    s40 = struct('Label', 'Multi 40', 'Model', PC);
    save('sceneLib/s40.mat', 's40');
    drawModel(s40.Model, 'Scene 40');
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