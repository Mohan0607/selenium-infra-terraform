package com.Facebook.Utilities;

import com.mailosaur.MailosaurClient;
import com.mailosaur.MailosaurException;
import com.mailosaur.models.Message;
import com.mailosaur.models.MessageSearchParams;
import com.mailosaur.models.SearchCriteria;
import net.serenitybdd.model.environment.EnvironmentSpecificConfiguration;
import net.thucydides.model.environment.SystemEnvironmentVariables;
import net.thucydides.model.util.EnvironmentVariables;


import java.io.IOException;

import static org.junit.Assert.assertNotNull;

public class mailReader {

    private EnvironmentVariables environmentVariables;
    MailosaurClient mailosaur;
    MessageSearchParams params;

    public mailReader(){
//        environmentVariables = Injectors.getInjector().getInstance(EnvironmentVariables.class);
        environmentVariables = SystemEnvironmentVariables.createEnvironmentVariables();
        String apiKey = EnvironmentSpecificConfiguration.from(environmentVariables).getPropertyValue("mailosaur.apiKey");
        String serverId = EnvironmentSpecificConfiguration.from(environmentVariables).getPropertyValue("mailosaur.serverId");
        String serverDomain = EnvironmentSpecificConfiguration.from(environmentVariables).getPropertyValue("mailosaur.serverDomain");
        System.out.println("mailosaur.apiKey"+apiKey);
        System.out.println("mailosaur.serverId"+serverId);
        System.out.println("mailosaur.serverDomain"+serverDomain);

        mailosaur = new MailosaurClient(apiKey);
        params = new MessageSearchParams();
        params.withServer(serverId);
    }

    public String bodyMessage(String email){
        SearchCriteria criteria = new SearchCriteria();
        criteria.withSentTo(email);
        try {
            Message message = mailosaur.messages().get(params,criteria);
            assertNotNull(message);
            return message.html().body();
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } catch (MailosaurException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
