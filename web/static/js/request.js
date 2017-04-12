import { pairs } from './utils';

export function request(url, options, callback) {
    let xhr = new XMLHttpRequest();
    let method = options && options.method || 'GET';
    let body = method !== 'GET' && options && options.body
        ? JSON.stringify(options.body) : null;
    let headers = options && options.headers || {};
    if (!headers['Content-Type']) {
        headers['Content-Type'] = 'application/json';
    }

    if (typeof options === 'function') {
        callback = options;
    }

    if (typeof callback !== 'function') {
        throw new Error('Callback should be a function.');
    }

    if (method === 'GET' && options && options.query) {
        let query = pairs(options.query).map(p => p.join('=')).join('&');
        if (query) {
            url = url + '?' + query;
        }
    }

    xhr.open(method, url, true);

    if (headers) {
        for (let key in headers) {
            xhr.setRequestHeader(key, headers[key]);
        }
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            let response = ~xhr.getResponseHeader('Content-Type').indexOf('application/json')
                ? JSON.parse(xhr.responseText)
                : xhr.responseText;
            callback(null, response);
        }
    }

    xhr.send(body);
}
