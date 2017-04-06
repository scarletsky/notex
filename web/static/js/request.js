import { pairs } from './utils';

export function request(url, options, callback) {
    let xhr = new XMLHttpRequest();
    let method = options && options.method || 'GET';
    let body = method === 'GET' && options && options.body
        ? JSON.stringify(options.body) : null;

    if (typeof options === 'function') {
        callback = options;
    }

    if (typeof callback !== 'function') {
        throw new Error('Callback should be a function.');
    }

    if (method === 'GET' && options && options.query) {
        console.log(pairs(options.query))
        let query = pairs(options.query).map(p => p.join('=')).join('&');
        if (query) {
            url = url + '?' + query;
        }
    }

    xhr.open(method, url, true);

    if (options.headers) {
        for (let key in options.headers) {
            xhr.setRequestHeader(key, options.headers[key]);
        }
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            callback(null, xhr.responseText)
        }
    }

    xhr.send(body);
}
