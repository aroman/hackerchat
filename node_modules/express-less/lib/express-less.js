/*
 * Express LESS middleware.
 *
 * Copyright (C) 2013  Andrew A. Usenok
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

'use strict';

var fs = require('fs'),
	url = require('url'),
	path = require('path'),
	less = require('less');

module.exports = function(root, options) {
	var options = options || {};
	var root = root || __dirname + '/less';

	return function(req, res, next) {
		if (req.method != 'GET' && req.method != 'HEAD') { return next(); }

		var pathname = url.parse(req.url).pathname;
		if (path.extname(pathname) != '.css') { return next(); }

		var src = path.join(
			root,
			path.dirname(pathname),
			path.basename(pathname, '.css') + '.less'
		);

		fs.readFile(src, function(err, data) {
			if (err) { return next(); }

			var parser = new less.Parser({
				paths: [root],
				filename: path.basename(src)
			});

			parser.parse(new String(data), function(err, tree) {
				if (err) { return res.send(500); }

				res.set('Content-Type', 'text/css');
				res.send(tree.toCSS({ compress: options.compress }));
			});
		});
	};
};
