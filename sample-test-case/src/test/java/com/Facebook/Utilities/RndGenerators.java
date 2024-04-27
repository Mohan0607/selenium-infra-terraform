package com.Facebook.Utilities;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.RandomUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class RndGenerators {
    public static Logger log = LogManager.getLogger(RndGenerators.class);

    public String RndEmail() {
        String RndEmailName = RndSmallString(10);
        String RndFullEmail = RndEmailName + "@xxafh5gg.mailosaur.net";
        log.info("Random Generated Email is: " + RndFullEmail);
        return RndFullEmail;
    }

    public String RndString(int Count) {
        String RndString = RandomStringUtils.randomAlphabetic(Count);
        log.info("Random Generated String is: " + RndString);
        return RndString;
    }

    public int RndInteger(int MinNumber, int MaxNumber) {
        int RndInt = RandomUtils.nextInt(MinNumber, MaxNumber);
        log.info("Random Generated Integer with given range is: " + RndInt);
        return RndInt;
    }

    public String RndCellPhoneNum() {
        String stringValue = "9";
        for (int i = 0; i < 9; i++) {
            stringValue += (char) RndInteger(48, 57);
        }
        return stringValue;
    }

    public String RndSmallString(int stringlenth) {
        String stringValue = "test";
        for (int i = 0; i < stringlenth - 4; i++) {
            stringValue += (char) RndInteger(97, 122);
        }
        return stringValue;
    }

}
