package com.Facebook.runners;
import  io.cucumber.junit.CucumberOptions;
import net.serenitybdd.cucumber.CucumberWithSerenity;
import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;
import org.junit.runner.RunWith;
import static io.cucumber.junit.platform.engine.Constants.*;


@RunWith(CucumberWithSerenity.class)
@CucumberOptions(
        plugin = {"pretty"},
        features = "src/test/resources/features",
        glue = {"com.Facebook.stepDefinitions"},
        dryRun = false,
        tags = "@facebook")
@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(key = FILTER_TAGS_PROPERTY_NAME, value = "@facebook")
@ConfigurationParameter(key = FEATURES_PROPERTY_NAME, value = "src/test/resources")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "com/Facebook/stepDefinitions")


public class TestRunner {
}
