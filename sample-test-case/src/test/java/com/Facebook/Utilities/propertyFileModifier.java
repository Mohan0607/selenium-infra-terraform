package com.Facebook.Utilities;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

public class propertyFileModifier {
    private PropertiesConfiguration TestResults;
    private final String TestResultsPropertyFilePath = System.getProperty("user.dir") + "/src/test/resources/TestResults/TestResults.properties";

    public propertyFileModifier() {
        try {
            TestResults = new PropertiesConfiguration(TestResultsPropertyFilePath);
        } catch (ConfigurationException e) {
            e.printStackTrace();
        }
    }

    public String getProperty(String PropertyName) {
        String PropertyValue = (String) TestResults.getProperty(PropertyName);
        if (PropertyValue != null) return PropertyValue;
        else
            throw new RuntimeException("Property Key provided do not have any record in the Test Results properties file");
    }

    public void setProperty(String PropertyName, String Value) {
        TestResults.setProperty(PropertyName, Value);
        try {
            TestResults.save();
        } catch (ConfigurationException e) {
            e.printStackTrace();
        }
        System.out.println("For the Property:: " + PropertyName + " ::Value - " + Value + " has been set in Test Results properties file");
    }
}
