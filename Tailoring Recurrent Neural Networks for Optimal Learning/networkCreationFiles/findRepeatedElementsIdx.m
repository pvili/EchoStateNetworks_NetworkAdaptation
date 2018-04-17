function index=findRepeatedElementsIdx(A)
    [n, bin] = histc(A, unique(A));
    multiple = find(n > 1);
    index    = find(ismember(bin, multiple));
end