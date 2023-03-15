function y = fitter(x,a,b,n)


y = zeros(size(x));

    for i = 1:length(x)
        y(i) =sqrt(a+b*(x(i).^n));
    end
end
