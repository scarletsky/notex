export function trim (str) {
    
}

export function keys (object) {
    let result = [];
    for (let key in object) {
        result.push(key);
    }
    return result;
}

export function pairs (object) {
    return keys(object).map(k => [ k, object[k] ]);
}
