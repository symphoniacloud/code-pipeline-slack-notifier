var request = require('request');

const SLACK_URL = process.env.SLACK_URL;

exports.handler = (event, context, callback) => {
    request(generateRequestDetails(event, SLACK_URL), function (err, res, body) {
        if (res && (res.statusCode === 200 || res.statusCode === 201)) {
            callback(null, 'Done');
        }
        else {
            console.log('Error: ' + err + ' ' + res + ' ' + body);
            callback('Error');
        }
    });
};

function generateRequestDetails(event, url) {
    if (event['detail-type'] != "CodePipeline Pipeline Execution State Change")
        throw new Error ("Unsupported detail type: " + event['detail-type']);


    var color;
    var text = "CodePipeline " + event.detail.pipeline + " ";
    var pipelineState = event.detail.state;
    if (pipelineState == 'STARTED') {
        color = "#888888";
        text += "has started."
    }
    else if (pipelineState == 'SUCCEEDED') {
        color = "good";
        text += "has *succeeded*.";
    }
    else if (pipelineState == 'FAILED') {
        color = "danger";
        text += "has *failed*.";
    }
    else if (pipelineState == 'CANCELED') {
        color = "warning";
        text += "was canceled.";
    }
    else if (pipelineState == 'RESUMED') {
        color = "#888888";
        text += "has resumed.";
    }
    else {
        color = "warning";
        text += "has " + pipelineState + " (This is an unknown state to the Slack notifier.)";
    }

    console.log('Posting following message to Slack: ' + text);

    var options = {
        url: url,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        json: {
            attachments: [ {text: text, color: color}]
        }
    };

    return options;
}

exports.__test__ = {
    generateRequestDetails: generateRequestDetails
};
