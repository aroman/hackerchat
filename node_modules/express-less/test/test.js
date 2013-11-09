'use strict';

var express = require('express'),
    request = require('supertest'),
    expressLess = require('../');

var app = express();
app.use(expressLess(__dirname + '/fixtures'));

describe('Express LESS', function() {
	it('should return valid CSS', function(done) {
		request(app)
			.get('/valid.css')
			.expect('Content-Type', /css/)
			.expect(/color: #aabbcc/)
			.expect(200, done);
	});

	it('should ignore methods other than GET and HEAD', function(done) {
		request(app)
			.post('/valid.css')
			.expect(404, done);
	});

	it('should respond with 404 if input file not found', function(done) {
		request(app)
			.get('/phantom.css')
			.expect(404, done);
	});

	it('should respond with 500 if input file is invalid', function(done) {
		request(app)
			.get('/invalid.css')
			.expect(500, done);
	});
});
