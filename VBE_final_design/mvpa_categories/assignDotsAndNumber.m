function dottedMat = assignDotsAndNumber(strList, properties)

for s = 1:length(strList)

    dottedMat(s,1) = strList(s);
    dottedMat(s,2) = brailify(strList(s),properties);

    thisStr = char(strList(s));
    numDots = 0;

    for c = 1:length(char(strList(s)))

        switch thisStr(c)
            case 'a' % 1 
                numDots = numDots +1;

            case {'b','c','k','e','i'} % 2
                numDots = numDots + 2;

            case {'d','f','h','l','j','m','s','o','u'} % 3
                numDots = numDots + 3;

            case {'g','n','p','r','t','v','w','x','z'} % 4
                numDots = numDots + 4;

            case {'y','q'} % 5
                numDots = numDots + 5;

            case 'é' % 6
                numDots = numDots + 6;
        end

    end

    dottedMat(s,3) = numDots;

end

end