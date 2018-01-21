package io.symphonia;

import java.io.IOException;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;

import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

public class CPLambda {
	public static final String SLACK_URL = System.getenv("SLACK_URL");

	public void handler(CWPipelineEvent input) throws IOException {
		String message = "CodePipeline ";
		CWPipelineAttachment attachment = new CWPipelineAttachment();
		attachment.color = "#888888";
		if (input != null) {
			String state = input.detail != null && input.detail.state != null ? input.detail.state.toLowerCase()
					: "unknown";
			message += "_" + (input.detail != null ? input.detail.pipeline : "unknown") + "_";
			if (input.detail != null && input.detail.stage != null)
				message += ", stage _" + input.detail.stage + "_";
			switch (state) {
			case "started":
				message += " has " + state;
				if (input.detail != null && (input.detail.stage != null || input.detail.action != null)) {
					// do not report started events for each and every stage or action
					return;
				}
				break;
			case "succeeded":
				message += " has " + "*" + state + "*";
				attachment.color = "good";
				if (input.detail != null && (input.detail.stage != null && input.detail.action != null)) {
					// do not report succeeded events for each and every stage and action
					return;
				}
				break;
			case "failed":
				message += " has " + "*" + state + "*";
				attachment.color = "danger";
				break;
			default:
				message += " has " + state;
			}
			// attachment.text = input.toString();
			attachment.text = "Time: " + input.time + ", Region: " + input.region + "\n<https://" + input.region
					+ ".console.aws.amazon.com/codepipeline/home?region=" + input.region + "#/view/"
					+ (input.detail != null ? input.detail.pipeline : "unknown") + "|CodePipeline>";
		} else {
			message += "without valid input";
			attachment.color = "danger";
			attachment.text = "No information available";
		}
		System.out.println(message);
		sendToSlack(message, attachment);
	}

	public static void sendToSlack(String message, CWPipelineAttachment attachment) throws IOException {
		if (SLACK_URL == null || SLACK_URL.length() == 0) {
			System.err.println("Unable to retrieve SLACK_URL from environment");
			return;
		}

		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost(SLACK_URL);
		httpPost.setHeader("Content-type", "application/json");
		String msg = "{\"text\" : \"" + message + "\", \"username\": \"CodePipeline\",";
		msg += "\"attachments\": [{";
		msg += "\"color\":\"" + attachment.color + "\",";
		msg += "\"text\":\"" + attachment.text + "\"";
		msg += "}]";
		msg += "}";
		System.out.println(msg);
		httpPost.setEntity(new StringEntity(msg));
		client.execute(httpPost);
		client.close();
	}

	/////////////////////////////////////////////////////////////////////////

	public static class CWPipelineEvent {
		public CWPipelineEventDetail detail;
		public String id;
		public String account;
		public String time;
		public String region;
		public String source;
		public List<String> resources;
		@XmlAttribute(name = "detail-type")
		public String detailType;

		@Override
		public String toString() {
			return "CWPipelineEvent [detail=" + detail + ", id=" + id + ", account=" + account + ", time=" + time
					+ ", region=" + region + ", source=" + source + ", resources=" + resources + ", detailType="
					+ detailType + "]";
		}

	}

	/////////////////////////////////////////////////////////////////////////

	public static class CWPipelineEventDetail {
		public String pipeline;
		public String state;
		public String version;
		@XmlAttribute(name = "execution-id")
		public String executionId;
		public String stage;
		public String action;
		public CWPipelineType type;

		@Override
		public String toString() {
			return "CWPipelineEventDetail [pipeline=" + pipeline + ", state=" + state + ", version=" + version
					+ ", executionId=" + executionId + ", stage=" + stage + ", action=" + action + ", type=" + type
					+ "]";
		}
	}

	/////////////////////////////////////////////////////////////////////////

	public static class CWPipelineType {
		public String owner;
		public String category;

		@Override
		public String toString() {
			return "CWPipelineType [owner=" + owner + ", category=" + category + ", provider=" + provider + ", version="
					+ version + "]";
		}

		public String provider;
		public String version;

	}

	/////////////////////////////////////////////////////////////////////////

	public static class CWPipelineAttachment {
		public String color;
		public String text;
	}

}
