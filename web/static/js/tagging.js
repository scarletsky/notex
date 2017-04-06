import utils from './utils';
import { request } from './request';

export function tagging(target, options) {

    let isLoading = false;

    function createTag(tag, callback) {
        request('/api/tags', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: { tag: tag }
        }, callback);
    }

    function listTags(query, callback) {
        request('/api/tags', { query: query }, callback);
    }

    function onKeyup(e) {

        let input = e.target.value;

        if (e.which === 13) {
            e.preventDefault();
            createTag({ name: input }, function (err, res) {
                console.log(err, res);
            });
        } else {
            listTags({ name: input }, function (err, res) {
                console.log(err, res);
            });
        }
    }

    target.addEventListener('keyup', onKeyup);
}
