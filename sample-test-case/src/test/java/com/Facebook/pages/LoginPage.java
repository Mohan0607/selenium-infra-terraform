package com.Facebook.pages;

import com.Facebook.base.baseClass;
import net.serenitybdd.annotations.Step;
import net.serenitybdd.core.pages.WebElementFacade;
import net.serenitybdd.model.SerenitySystemProperties;
import net.thucydides.model.ThucydidesSystemProperty;
import org.openqa.selenium.support.FindBy;

public class LoginPage extends baseClass {


    @FindBy(xpath = "//input[@formcontrolname='username']")
    WebElementFacade username_txt;

    @FindBy(xpath = "//input[@formcontrolname='password']")
    WebElementFacade pass_txt;

    @FindBy(tagName = "button")
    WebElementFacade login_btn;

    @FindBy(xpath = "//div[@class='cdk-overlay-container']//nz-notification-container//div[contains(text(),'Error')]")
    WebElementFacade error_popup;



    @Step
    public void username() {
        open();
        String property = SerenitySystemProperties.getProperties().getValue(ThucydidesSystemProperty.WEBDRIVER_BASE_URL);
        setVariables();
        username_txt.isDisplayed();
        typeInto(username_txt, dynamicvariables.get_username());

    }
    @Step
    public void password() {
        typeInto(pass_txt, dynamicvariables.get_password());
    }

    @Step
    public void verifyErrorMessage(String msg) {
        error_popup.shouldContainText(msg);
    }

    @Step
    public void clickLoginbtn() {
        clickOn(login_btn);
    }


}

