// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This code is intended for quick and dirty tests.
// Don't use in live environments!
library StringHlp {
    
    // Get the number of bytes in a string. This is not truely the string 
    // length becuase of strings being UTF-8.
    function getLength(string memory str) public pure returns (uint) {
        bytes memory strBytes = bytes(str);
        return strBytes.length;
    }    

    //Searching for a byte sequence in another byte sequence
    function indexOf(bytes memory haystack, bytes memory needle, uint startIndex) internal pure returns (int) {
        if (haystack.length < needle.length || needle.length == 0)
            return -1;
            
        for (uint uPos = startIndex; uPos <= haystack.length - needle.length; uPos++) {
            bool found = true;

            for (uint jPos = 0; jPos < needle.length; jPos++) {
                if (haystack[uPos + jPos] != needle[jPos]) {
                    found = false;
                    break;
                }
            }
            if (found)
                return int(uPos);
        }
        
        return -1;
    }    

    function searchString(string memory haystack, string memory needle, uint startIndex) public pure returns (int) {
        bytes memory haystackBytes = bytes(haystack);
        bytes memory needleBytes = bytes(needle);
        
        if (needleBytes.length > haystackBytes.length)
            return -1;
            
        return indexOf(haystackBytes, needleBytes, startIndex);
    }   

    function sliceString(string memory strIn, uint uStart, uint uEnd) public pure returns (string memory) {
        require(uEnd >= uStart);
        require(uEnd < getLength(strIn));

        if (uEnd == uStart) 
            return "";

        bytes memory inputBytes = bytes(strIn);
        bytes memory substring = new bytes(uEnd - uStart + 1);
        
        for (uint uPos = uStart; uPos <= uEnd; uPos++) {
            substring[uPos - uStart] = inputBytes[uPos];
        }

        return string(substring);
    }    

    //Setup state of Denial contract for testing
    function getEnvString(string memory envText, string memory envKey) public pure returns (string memory) {

        uint uEnvLen  = getLength(envText);

        //Look for the key...
        int iKeyStart = searchString(envText, envKey, 0);
        require(iKeyStart > 0, "Cannot find env key");

        //Compute value start
        uint uValueStart = uint(iKeyStart) + getLength(envKey);

        //Compute value end
        int iValueEnd = searchString(envText, "\n", uValueStart);
        if (iValueEnd == -1) iValueEnd = int(uEnvLen);

        //Extract value
        return sliceString(envText, uValueStart, uint(iValueEnd));
    }
}