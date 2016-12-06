function [] = showCorrespondanse( P1, P2, I1, I2 )
%Helper method to display corresponding points in a pair of images

[height, width, ~] = size(I1);
imshow([I1, I2]); hold on;

plot(P1(:,1), P1(:,2), '+', 'Color', 'blue');
plot(P2(:,1)+width, P2(:,2), '+', 'Color', 'red');
plot([P1(:,1),P2(:,1)+width]', [P1(:,2),P2(:,2)]', '-');

hold off;
end

