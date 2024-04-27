package com.Facebook.stepDefinitions;

import com.Facebook.pages.LoginPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import net.serenitybdd.annotations.Steps;

public class login_StepDefinition {

    @Steps
    LoginPage loginPage;



    @When("I click login button")
    public void i_click_login_button() {
        loginPage.clickLoginbtn();
    }

    @Then("error message should be displayed as {string}")
    public void error_message_should_be_displayed_as(String msg) {
        loginPage.verifyErrorMessage(msg);
    }

    @Given("I have given {string} as username")
    public void iHaveGivenAsUsername(String name) {

    }

    @And("I have  given {string} as  password")
    public void iHaveGivenAsPassword(String pass) {

    }


    @Given("I have given valid as username")
    public void iHaveGivenValidAsUsername() {

    }

    @Given("I have given valid username")
    public void iHaveGivenValidUsername() {
        loginPage.username();
    }

    @And("I have  given valid password")
    public void iHaveGivenValidPassword() {
        loginPage.password();
    }








}
