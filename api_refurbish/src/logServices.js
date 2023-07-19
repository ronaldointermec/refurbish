const axios = require('axios');

module.exports = {
    addLog(msg, sev = 'INFO', rota, query_params, sql, method, headers, controller) {
        console.log(`[ADD LOG] ${msg}`);

        let logJSON = {
            log_message: msg,
            severity: sev,
            route: rota,
            query_params: JSON.stringify(query_params),
            sql: sql,
            method: method,
            headers: JSON.stringify(headers),
            controller: controller,
        };

        const body = {
            Stringfy: JSON.stringify(logJSON), //.replaceAll('\\', '')
        };

        console.log(body);
        postLog(body);
    },
};

async function postLog(body) {
    console.log(typeof body);

    const headers = {
        'Content-Type': 'application/json',
        Accept: '*/*',
        'Cache-Control': 'no-cache',
    };
    const url = 'http://hic032553.dc.honeywell.com/api/Log?topic=api_refurbish';

    axios
        .post(url, body)
        .then((res) => {
            // console.log(`acho que deu certo: ${res.status}`)
        })
        .catch((err) => {
            if (err.response) {
                console.log('response  error');
            } else if (err.request) {
                console.log('request  error');
            } else if (err.message) {
                console.log('message  error');
            }
            console.log(err.message);
        });
}
