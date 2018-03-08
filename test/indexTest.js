var assert = require('assert'),
  index = require('../lib/index.js').__test__;

const testInput = {
  "version": "0",
  "id": "d852b55d-a96a-e396-2e34-107bc39d1e21",
  "detail-type": "CodePipeline Pipeline Execution State Change",
  "source": "aws.codepipeline",
  "account": "123456789012",
  "time": "2018-02-23T16:54:45Z",
  "region": "us-west-2",
  "resources": [
    "arn:aws:codepipeline:us-west-2:123456789012:serverless-weather-build-CodePipeline-ABCDEFGHIJKL"
  ],
  "detail": {
    "pipeline": "serverless-weather-build-CodePipeline-ABCDEFGHIJKL",
    "execution-id": "1620f6b6-6731-4d93-aa3c-123456789012",
    "state": "STARTED",
    "version": 1
  }
};

const expectedSlackMessage = {
  url: "http://foo/bar",
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  }
  ,
  json: {
    attachments: [
      {
        "color": "#888888",
        "text": "CodePipeline serverless-weather-build-CodePipeline-ABCDEFGHIJKL has started."
      }]
  }
};

describe('generateRequestDetails', function () {
  it('should generate correct details to post to slack', function () {
    assert.deepEqual(
      expectedSlackMessage,
      index.generateRequestDetails(testInput, "http://foo/bar"));
  });
});
