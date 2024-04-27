package com.Facebook.base;


import net.serenitybdd.core.pages.PageObject;
import net.serenitybdd.model.SerenitySystemProperties;
import net.thucydides.model.ThucydidesSystemProperty;

import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

public class baseClass extends PageObject {
    public static void setVariables() {
        String env = SerenitySystemProperties.getProperties().getValue(ThucydidesSystemProperty.ENVIRONMENT);
        if (env == null) {
            env = "qa";
        }
        switch (env.toLowerCase()) {
            case "qa":
                dynamicvariables.set_username("TestFacebook");
                dynamicvariables.set_password("dfdfdg@123");
                break;
            default:
        }
    }


    public static class dynamicvariables {
        public static String username;
        public static String password;


        public static String get_username() {
            return username;
        }

        public static void set_username(String value) {
            username = value;
        }

        public static String get_password() {
            return password;
        }

        public static void set_password(String value) {
            password = value;
        }


    }
}
