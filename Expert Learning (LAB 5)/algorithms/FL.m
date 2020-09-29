function pred = FL(exp_loss, exp_advice)
    [C,I] = min(sum(exp_loss,2));
pred = exp_advice(I);