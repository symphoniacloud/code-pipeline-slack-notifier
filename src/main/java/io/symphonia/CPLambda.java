package io.symphonia;

import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;

public class CPLambda {
    public static final String SLACK_URL = System.getenv("SLACK_URL");

    public void handler(CWPipelineEvent event) throws IOException {
        final String message = "Pipeline " + event.detail.pipeline + " " + event.detail.state;
        System.out.println(message);
        sendToSlack(message);
    }

    public static class CWPipelineEvent {
        public CWPipelineEventDetail detail;

        public static class CWPipelineEventDetail {
            public String pipeline;
            public String state;
        }
    }

    public static void sendToSlack(String message) throws IOException {
        if (SLACK_URL == null || SLACK_URL.length() == 0) {
            System.err.println("Unable to retrieve SLACK_URL from environment");
            return;
        }

        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(SLACK_URL);
        httpPost.setHeader("Content-type", "application/json");
        httpPost.setEntity(new StringEntity("{\"text\" : \"" + message + "\"}"));
        client.execute(httpPost);
        client.close();
    }
}
